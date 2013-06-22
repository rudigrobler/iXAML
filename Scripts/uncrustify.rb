#!/usr/bin/env ruby
###########################################################################
# Script to be called as an Xcode 4 behaviour which will attempt to
# uncrustify all source files in the open project.
#
# (c) Copyright 2012 David Wagner.
#
# Complain/commend: http://noiseandheat.com/
#
#*************************************************************************#
#  IT WILL OVERWRITE YOUR SOURCE FILES WITHOUT WARNING SO IF YOU WANT TO  #
# RESTORE WHAT YOU HAD BEFORE RUNNING IT,  MAKE SURE YOUR FILES ARE UNDER #
#                    SOURCE CONTROL AND COMMITTED!                        #
#*************************************************************************#
#
# Assumptions this script makes
# =============================
#
#    - You already have uncrustify installed. If not, install
#      homebrew and use that to install it: `brew install uncrustfy`
#      See: http://mxcl.github.com/homebrew/
#
#    - If your project is called foo and located in bar, the script assumes
#      your source layout is similar to:
#
#          bar
#          ├── foo
#          │   └── <project source files>
#          └── foo.xcodeproj
#
#       That is, it will only look for source files in bar/foo/**
#
#    - It only tries to process header files, Objective-C files,
#      Objective-C++ files, C files and C++ files. It tries to guess
#      the correct source type for the header files based on an
#      associated source file with the same name (e.g. bob.h, bob.cpp)
#
#    - The configuration used to format the files is stored at
#      $HOME/.nah_xcode_uncrustify.cfg. If this file does not exist
#      a default one will be created there. You can see the default
#      at the end of this script after the __END__ tag.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Licensed under the MIT license:
#
#     http://www.opensource.org/licenses/mit-license.php
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
###########################################################################

# Location of uncrustify config. A default one will be created here if
# none exists

UNCRUSTIFY_CONFIG_FILE = File.join ENV['HOME'], '.uncrustify.cfg'

# Valid extensions of file to uncrust
VALID_EXTENSIONS = ['m', 'mm', 'h', 'c', 'cc', 'cp', 'cpp']

#
# Given /foo/bar/thing.bob, it will
# return "/foo/bar", "thing.bob", "thing", ".bob"
#
def explode_filepath_to_dir_basename_name_ext(filepath)
  dir = File.dirname(filepath)
  basename = File.basename(filepath)
  ext = File.extname(basename)
  name = File.basename(basename, ext)

  return dir, basename, name, ext
end

#
# Recursively gathers all files from the specified
# path who have one o the specifed extensions
#
def gather_all_sourcefiles(path, *extensions)
  extension_glob = "*.{#{extensions.join(',')}}"
  return Dir.glob(File.join(path, '**', extension_glob), File::FNM_CASEFOLD)
end

#
# Generates a array of uncrustfy specs from an array
# of file paths.
#
# A spec is simply a hash containing :source which
# is the source file full path and :forcetype which
# can optionally be used to force the filetype. If
# :forcetype is nil, leave it up to uncrustify to
# decide
#
def generate_uncrustify_specs(filelist)
  file_specs = [];
  filelist.each {
    |file|
    dir, filename, name, ext = explode_filepath_to_dir_basename_name_ext(file)

    # If it's a header file, do some craziness to work out the file type
    sourcetype = nil
    if ext.downcase == '.h'
      if filelist.any? { |companion| companion =~ /\/#{name}\.mm$/i }
        sourcetype = "OC+"
      elsif filelist.any? { |companion| companion =~ /\/#{name}\.(cc|cp|cpp)$/i }
        sourcetype = "CPP"
      elsif filelist.any? { |companion| companion =~ /\/#{name}\.c$/i }
        sourcetype = "C"
      else
        # Assume Objective-C
        sourcetype = "OC"
      end
    end

    file_specs << {
      :source => file,
      :forcetype => sourcetype
    }
  }
  return file_specs
end

#
# Runs the uncrustify command for the given spec
# dictionary. See generate_uncrustify_specs for
# a description of the spec.
#
def uncrust(spec)
  forcetype = spec[:forcetype] ? "-l #{spec[:forcetype]}" : ""
  %x[#{UNCRUSTIFY_BIN} #{forcetype} -c #{UNCRUSTIFY_CONFIG_FILE} --no-backup '#{spec[:source]}']
end

#
# Searches some likely locations for an executable
#
def find_binary(name)
  fullpath = nil;
  locations = [
    '/usr/local/bin',
    '/opt/local/bin',
    '/usr/bin',
    '/bin',
    '/usr/local/sbin',
    '/usr/sbin',
    '/sbin'
  ].any? { |path|
    searchpath = File.join(path, name)
    fullpath = searchpath if File.exist? searchpath
  }
  return fullpath
end

#
# Ensures the ~/.nah_xcode_uncrustify.cfg
# exists, or creates it if not
#
def ensure_config_file
  if not File.exist? UNCRUSTIFY_CONFIG_FILE
    File.open(UNCRUSTIFY_CONFIG_FILE, 'w') {|f| DATA.each_line { |l| f.write l } }
  end
end

#
# Can't find uncrustify, exit with an error
#
def error_no_uncrustify
  $stderr.puts %{}
  $stderr.puts %{Could not locate the uncrustify executable.}
  $stderr.puts %{}
  if find_binary('brew') != nil
    $stderr.puts %{You can install it via homebrew:}
    $stderr.puts %{    brew install uncrustify}
  else
    $stderr.puts %{You can install uncrustify via homebrew package manager.}
    $stderr.puts %{}
    $stderr.puts %{To install homebrew, see:}
    $stderr.puts %{    http://mxcl.github.com/homebrew/}
  end
  exit 1
end

#
# Exit with an error message, but show usage
#
def error_show_usage_and_exit(message)
  $stderr.puts %[#{message}]
  $stderr.puts %[]

  show_usage

  exit 1
end

#
# Shows usage instructions
#
def show_usage
  $stdout.puts "Usage"
  $stdout.puts "====="
  $stdout.puts ""
  $stdout.puts "WARNING: Files are editied WITHOUT backup. You should protect"
  $stdout.puts "the files with your version control system of choice before"
  $stdout.puts "running this script!"
  $stdout.puts ""
  $stdout.puts "Examples:"
  $stdout.puts ""
  $stdout.puts "  Uncrust from the current directory:"
  $stdout.puts "      #{File.basename(__FILE__)} ."
  $stdout.puts ""
  $stdout.puts "  Uncrust files in directory './foo':"
  $stdout.puts "      #{File.basename(__FILE__)} foo"
  $stdout.puts ""
  $stdout.puts "  Uncrust files in directory '/User/bob/dirtyproject':"
  $stdout.puts "      #{File.basename(__FILE__)} /User/bob/dirtyproject"
  $stdout.puts ""
end

###########################################################################
# Do eet
###########################################################################

# Location of uncrustify
UNCRUSTIFY_BIN = find_binary "uncrustify"

error_no_uncrustify if UNCRUSTIFY_BIN == nil

# The working path varies depending on whether a workspace is opened or
# if a project is openend.
XcodeWorkingPath = ENV['XcodeProjectPath'] || ENV['XcodeWorkspacePath']

if XcodeWorkingPath
  PROJECT_DIR, XCODEPROJ, PROJECT_NAME = explode_filepath_to_dir_basename_name_ext(XcodeWorkingPath)

  CRUSTY_PATH = File.join(PROJECT_DIR, PROJECT_NAME)
else
  error_show_usage_and_exit("No directory specified.") if ARGV.length == 0
  error_show_usage_and_exit("Could not find #{ARGV[0]}") unless File.exist? ARGV[0]
  error_show_usage_and_exit("#{ARGV[0]} is not a directory.") unless File.directory? ARGV[0]

  CRUSTY_PATH = File.expand_path ARGV[0]

  puts ""
  puts "Uncrustifying files in:"
  puts "   #{CRUSTY_PATH} "
  puts ""
end

FILES_TO_UNCRUST = gather_all_sourcefiles CRUSTY_PATH, *VALID_EXTENSIONS
FILE_SPECS = generate_uncrustify_specs FILES_TO_UNCRUST;

ensure_config_file

FILE_SPECS.each { |spec| uncrust spec }

###########################################################################
# A reasonable default Objective-C uncrustify configuration
###########################################################################
__END__
tok_split_gte=false
utf8_byte=false
utf8_force=false
indent_cmt_with_tabs=false
indent_align_string=true
indent_braces=false
indent_braces_no_func=false
indent_braces_no_class=false
indent_braces_no_struct=false
indent_brace_parent=false
indent_namespace=true
indent_extern=false
indent_class=false
indent_class_colon=false
indent_else_if=false
indent_var_def_cont=false
indent_func_call_param=false
indent_func_def_param=false
indent_func_proto_param=false
indent_func_class_param=false
indent_func_ctor_var_param=false
indent_template_param=false
indent_func_param_double=false
indent_relative_single_line_comments=false
indent_col1_comment=false
indent_access_spec_body=false
indent_paren_nl=false
indent_comma_paren=false
indent_bool_paren=false
indent_first_bool_expr=false
indent_square_nl=false
indent_preserve_sql=false
indent_align_assign=true
sp_balance_nested_parens=false
align_keep_tabs=false
align_with_tabs=true
align_on_tabstop=false
align_number_left=false
align_func_params=false
align_same_func_call_params=false
align_var_def_colon=false
align_var_def_attribute=false
align_var_def_inline=false
align_right_cmt_mix=false
align_on_operator=false
align_mix_var_proto=false
align_single_line_func=true
align_single_line_brace=false
align_nl_cont=false
align_left_shift=true
align_oc_decl_colon=false
nl_collapse_empty_body=false
nl_assign_leave_one_liners=false
nl_class_leave_one_liners=false
nl_enum_leave_one_liners=false
nl_getset_leave_one_liners=false
nl_func_leave_one_liners=false
nl_if_leave_one_liners=false
nl_multi_line_cond=false
nl_multi_line_define=false
nl_before_case=false
nl_after_case=false
nl_after_return=false
nl_after_semicolon=false
nl_after_brace_open=false
nl_after_brace_open_cmt=false
nl_after_vbrace_open=false
nl_after_vbrace_open_empty=false
nl_after_brace_close=false
nl_after_vbrace_close=false
nl_define_macro=false
nl_squeeze_ifdef=false
nl_ds_struct_enum_cmt=false
nl_ds_struct_enum_close_brace=false
nl_create_if_one_liner=false
nl_create_for_one_liner=false
nl_create_while_one_liner=false
ls_for_split_full=false
ls_func_split_full=false
nl_after_multiline_comment=false
eat_blanks_after_open_brace=false
eat_blanks_before_close_brace=false
mod_full_brace_if_chain=false
mod_pawn_semicolon=false
mod_full_paren_if_bool=false
mod_remove_extra_semicolon=false
mod_sort_import=true
mod_sort_using=false
mod_sort_include=false
mod_move_case_break=false
mod_remove_empty_return=false
cmt_indent_multi=true
cmt_c_group=false
cmt_c_nl_start=false
cmt_c_nl_end=false
cmt_cpp_group=false
cmt_cpp_nl_start=false
cmt_cpp_nl_end=false
cmt_cpp_to_c=false
cmt_star_cont=false
cmt_multi_check_last=true
cmt_insert_before_preproc=false
pp_indent_at_level=false
pp_region_indent_code=false
pp_if_indent_code=false
pp_define_at_level=false
indent_access_spec=0
nl_after_func_body=2
indent_with_tabs=2