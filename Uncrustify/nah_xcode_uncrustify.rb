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
UNCRUSTIFY_CONFIG_FILE = File.join ENV['HOME'], '.nah_xcode_uncrustify.cfg'

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
# Uncrustify 0.59

###########################################################################
# nah_xcode_uncrustify.rb default
# configuration
#
# config_version: 1.1.0
#
# Default uncrustify config to use for
# the nah_xcode_uncrustify.rb script
# available at:
#
#   http://noiseandheat.com
#
###########################################################################

#
# General options
#

# The type of line endings
newlines                                 = auto     # auto/lf/crlf/cr

# The original size of tabs in the input
input_tab_size                           = 8        # number

# The size of tabs in the output (only used if align_with_tabs=true)
output_tab_size                          = 8        # number

# The ASCII value of the string escape char, usually 92 (\) or 94 (^). (Pawn)
string_escape_char                       = 92       # number

# Alternate string escape char for Pawn. Only works right before the quote char.
string_escape_char2                      = 0        # number

# Allow interpreting '>=' and '>>=' as part of a template in 'void f(list<list<B>>=val);'.
# If true (default), 'assert(x<0 && y>=3)' will be broken.
# Improvements to template detection may make this option obsolete.
tok_split_gte                            = false    # false/true

# Control what to do with the UTF-8 BOM (recommed 'remove')
utf8_bom                                 = remove   # ignore/add/remove/force

# If the file only contains chars between 128 and 255 and is not UTF-8, then output as UTF-8
utf8_byte                                = false    # false/true

# Force the output encoding to UTF-8
utf8_force                               = false    # false/true

#
# Indenting
#

# The number of columns to indent per level.
# Usually 2, 3, 4, or 8.
indent_columns                           = 4        # number

# The continuation indent. If non-zero, this overrides the indent of '(' and '=' continuation indents.
# For FreeBSD, this is set to 4.
indent_continue                          = 0        # number

# How to use tabs when indenting code
# 0=spaces only
# 1=indent with tabs to brace level, align with spaces
# 2=indent and align with tabs, using spaces when not on a tabstop
indent_with_tabs                         = 0        # number

# Comments that are not a brace level are indented with tabs on a tabstop.
# Requires indent_with_tabs=2. If false, will use spaces.
indent_cmt_with_tabs                     = false    # false/true

# Whether to indent strings broken by '\' so that they line up
indent_align_string                      = true     # false/true

# The number of spaces to indent multi-line XML strings.
# Requires indent_align_string=True
indent_xml_string                        = 0        # number

# Spaces to indent '{' from level
indent_brace                             = 0        # number

# Whether braces are indented to the body level
indent_braces                            = false    # false/true

# Disabled indenting function braces if indent_braces is true
indent_braces_no_func                    = false    # false/true

# Disabled indenting class braces if indent_braces is true
indent_braces_no_class                   = false    # false/true

# Disabled indenting struct braces if indent_braces is true
indent_braces_no_struct                  = false    # false/true

# Indent based on the size of the brace parent, i.e. 'if' => 3 spaces, 'for' => 4 spaces, etc.
indent_brace_parent                      = false    # false/true

# Whether the 'namespace' body is indented
indent_namespace                         = false    # false/true

# The number of spaces to indent a namespace block
indent_namespace_level                   = 0        # number

# If the body of the namespace is longer than this number, it won't be indented.
# Requires indent_namespace=true. Default=0 (no limit)
indent_namespace_limit                   = 0        # number

# Whether the 'extern "C"' body is indented
indent_extern                            = false    # false/true

# Whether the 'class' body is indented
indent_class                             = false    # false/true

# Whether to indent the stuff after a leading class colon
indent_class_colon                       = false    # false/true

# Additional indenting for constructor initializer list
indent_ctor_init                         = 0        # number

# False=treat 'else\nif' as 'else if' for indenting purposes
# True=indent the 'if' one level
indent_else_if                           = false    # false/true

# Amount to indent variable declarations after a open brace. neg=relative, pos=absolute
indent_var_def_blk                       = 0        # number

# Indent continued variable declarations instead of aligning.
indent_var_def_cont                      = false    # false/true

# True:  indent continued function call parameters one indent level
# False: align parameters under the open paren
indent_func_call_param                   = false    # false/true

# Same as indent_func_call_param, but for function defs
indent_func_def_param                    = false    # false/true

# Same as indent_func_call_param, but for function protos
indent_func_proto_param                  = false    # false/true

# Same as indent_func_call_param, but for class declarations
indent_func_class_param                  = false    # false/true

# Same as indent_func_call_param, but for class variable constructors
indent_func_ctor_var_param               = false    # false/true

# Same as indent_func_call_param, but for templates
indent_template_param                    = false    # false/true

# Double the indent for indent_func_xxx_param options
indent_func_param_double                 = false    # false/true

# Indentation column for standalone 'const' function decl/proto qualifier
indent_func_const                        = 0        # number

# Indentation column for standalone 'throw' function decl/proto qualifier
indent_func_throw                        = 0        # number

# The number of spaces to indent a continued '->' or '.'
# Usually set to 0, 1, or indent_columns.
indent_member                            = 0        # number

# Spaces to indent single line ('//') comments on lines before code
indent_sing_line_comments                = 0        # number

# If set, will indent trailing single line ('//') comments relative
# to the code instead of trying to keep the same absolute column
indent_relative_single_line_comments     = false    # false/true

# Spaces to indent 'case' from 'switch'
# Usually 0 or indent_columns.
indent_switch_case                       = 4        # number

# Spaces to shift the 'case' line, without affecting any other lines
# Usually 0.
indent_case_shift                        = 0        # number

# Spaces to indent '{' from 'case'.
# By default, the brace will appear under the 'c' in case.
# Usually set to 0 or indent_columns.
indent_case_brace                        = 0        # number

# Whether to indent comments found in first column
indent_col1_comment                      = false    # false/true

# How to indent goto labels
#  >0 : absolute column where 1 is the leftmost column
#  <=0 : subtract from brace indent
indent_label                             = 1        # number

# Same as indent_label, but for access specifiers that are followed by a colon
indent_access_spec                       = 1        # number

# Indent the code after an access specifier by one level.
# If set, this option forces 'indent_access_spec=0'
indent_access_spec_body                  = false    # false/true

# If an open paren is followed by a newline, indent the next line so that it lines up after the open paren (not recommended)
indent_paren_nl                          = false    # false/true

# Controls the indent of a close paren after a newline.
# 0: Indent to body level
# 1: Align under the open paren
# 2: Indent to the brace level
indent_paren_close                       = 0        # number

# Controls the indent of a comma when inside a paren.If TRUE, aligns under the open paren
indent_comma_paren                       = false    # false/true

# Controls the indent of a BOOL operator when inside a paren.If TRUE, aligns under the open paren
indent_bool_paren                        = false    # false/true

# If 'indent_bool_paren' is true, controls the indent of the first expression. If TRUE, aligns the first expression to the following ones
indent_first_bool_expr                   = false    # false/true

# If an open square is followed by a newline, indent the next line so that it lines up after the open square (not recommended)
indent_square_nl                         = false    # false/true

# Don't change the relative indent of ESQL/C 'EXEC SQL' bodies
indent_preserve_sql                      = false    # false/true

# Align continued statements at the '='. Default=True
# If FALSE or the '=' is followed by a newline, the next line is indent one tab.
indent_align_assign                      = true     # false/true

#
# Spacing options
#

# Add or remove space around arithmetic operator '+', '-', '/', '*', etc
sp_arith                                 = force    # ignore/add/remove/force

# Add or remove space around assignment operator '=', '+=', etc
sp_assign                                = force    # ignore/add/remove/force

# Add or remove space around assignment operator '=' in a prototype
sp_assign_default                        = force    # ignore/add/remove/force

# Add or remove space before assignment operator '=', '+=', etc. Overrides sp_assign.
sp_before_assign                         = force    # ignore/add/remove/force

# Add or remove space after assignment operator '=', '+=', etc. Overrides sp_assign.
sp_after_assign                          = force    # ignore/add/remove/force

# Add or remove space around assignment '=' in enum
sp_enum_assign                           = force    # ignore/add/remove/force

# Add or remove space before assignment '=' in enum. Overrides sp_enum_assign.
sp_enum_before_assign                    = force    # ignore/add/remove/force

# Add or remove space after assignment '=' in enum. Overrides sp_enum_assign.
sp_enum_after_assign                     = force    # ignore/add/remove/force

# Add or remove space around preprocessor '##' concatenation operator. Default=Add
sp_pp_concat                             = add      # ignore/add/remove/force

# Add or remove space after preprocessor '#' stringify operator. Also affects the '#@' charizing operator. Default=Add
sp_pp_stringify                          = add      # ignore/add/remove/force

# Add or remove space around boolean operators '&&' and '||'
sp_bool                                  = force    # ignore/add/remove/force

# Add or remove space around compare operator '<', '>', '==', etc
sp_compare                               = force    # ignore/add/remove/force

# Add or remove space inside '(' and ')'
sp_inside_paren                          = remove   # ignore/add/remove/force

# Add or remove space between nested parens
sp_paren_paren                           = force    # ignore/add/remove/force

# Whether to balance spaces inside nested parens
sp_balance_nested_parens                 = true     # false/true

# Add or remove space between ')' and '{'
sp_paren_brace                           = force    # ignore/add/remove/force

# Add or remove space before pointer star '*'
sp_before_ptr_star                       = force    # ignore/add/remove/force

# Add or remove space before pointer star '*' that isn't followed by a variable name
# If set to 'ignore', sp_before_ptr_star is used instead.
sp_before_unnamed_ptr_star               = add      # ignore/add/remove/force

# Add or remove space between pointer stars '*'
sp_between_ptr_star                      = ignore   # ignore/add/remove/force

# Add or remove space after pointer star '*', if followed by a word.
sp_after_ptr_star                        = remove   # ignore/add/remove/force

# Add or remove space after a pointer star '*', if followed by a func proto/def.
sp_after_ptr_star_func                   = ignore   # ignore/add/remove/force

# Add or remove space before a pointer star '*', if followed by a func proto/def.
sp_before_ptr_star_func                  = ignore   # ignore/add/remove/force

# Add or remove space before a reference sign '&'
sp_before_byref                          = ignore   # ignore/add/remove/force

# Add or remove space before a reference sign '&' that isn't followed by a variable name
# If set to 'ignore', sp_before_byref is used instead.
sp_before_unnamed_byref                  = ignore   # ignore/add/remove/force

# Add or remove space after reference sign '&', if followed by a word.
sp_after_byref                           = ignore   # ignore/add/remove/force

# Add or remove space after a reference sign '&', if followed by a func proto/def.
sp_after_byref_func                      = ignore   # ignore/add/remove/force

# Add or remove space before a reference sign '&', if followed by a func proto/def.
sp_before_byref_func                     = ignore   # ignore/add/remove/force

# Add or remove space between type and word. Default=Force
sp_after_type                            = force    # ignore/add/remove/force

# Add or remove space in 'template <' vs 'template<'.
# If set to ignore, sp_before_angle is used.
sp_template_angle                        = ignore   # ignore/add/remove/force

# Add or remove space before '<>'
sp_before_angle                          = ignore   # ignore/add/remove/force

# Add or remove space inside '<' and '>'
sp_inside_angle                          = ignore   # ignore/add/remove/force

# Add or remove space after '<>'
sp_after_angle                           = ignore   # ignore/add/remove/force

# Add or remove space between '<>' and '(' as found in 'new List<byte>();'
sp_angle_paren                           = ignore   # ignore/add/remove/force

# Add or remove space between '<>' and a word as in 'List<byte> m;'
sp_angle_word                            = ignore   # ignore/add/remove/force

# Add or remove space between '>' and '>' in '>>' (template stuff C++/C# only). Default=Add
sp_angle_shift                           = add      # ignore/add/remove/force

# Add or remove space before '(' of 'if', 'for', 'switch', and 'while'
sp_before_sparen                         = force    # ignore/add/remove/force

# Add or remove space inside if-condition '(' and ')'
sp_inside_sparen                         = ignore   # ignore/add/remove/force

# Add or remove space before if-condition ')'. Overrides sp_inside_sparen.
sp_inside_sparen_close                   = ignore   # ignore/add/remove/force

# Add or remove space after ')' of 'if', 'for', 'switch', and 'while'
sp_after_sparen                          = ignore   # ignore/add/remove/force

# Add or remove space between ')' and '{' of 'if', 'for', 'switch', and 'while'
sp_sparen_brace                          = ignore   # ignore/add/remove/force

# Add or remove space between 'invariant' and '(' in the D language.
sp_invariant_paren                       = ignore   # ignore/add/remove/force

# Add or remove space after the ')' in 'invariant (C) c' in the D language.
sp_after_invariant_paren                 = ignore   # ignore/add/remove/force

# Add or remove space before empty statement ';' on 'if', 'for' and 'while'
sp_special_semi                          = ignore   # ignore/add/remove/force

# Add or remove space before ';'. Default=Remove
sp_before_semi                           = remove   # ignore/add/remove/force

# Add or remove space before ';' in non-empty 'for' statements
sp_before_semi_for                       = ignore   # ignore/add/remove/force

# Add or remove space before a semicolon of an empty part of a for statement.
sp_before_semi_for_empty                 = ignore   # ignore/add/remove/force

# Add or remove space after ';', except when followed by a comment. Default=Add
sp_after_semi                            = add      # ignore/add/remove/force

# Add or remove space after ';' in non-empty 'for' statements. Default=Force
sp_after_semi_for                        = force    # ignore/add/remove/force

# Add or remove space after the final semicolon of an empty part of a for statement: for ( ; ; <here> ).
sp_after_semi_for_empty                  = ignore   # ignore/add/remove/force

# Add or remove space before '[' (except '[]')
sp_before_square                         = ignore   # ignore/add/remove/force

# Add or remove space before '[]'
sp_before_squares                        = ignore   # ignore/add/remove/force

# Add or remove space inside a non-empty '[' and ']'
sp_inside_square                         = ignore   # ignore/add/remove/force

# Add or remove space after ','
sp_after_comma                           = ignore   # ignore/add/remove/force

# Add or remove space before ','
sp_before_comma                          = remove   # ignore/add/remove/force

# Add or remove space between an open paren and comma: '(,' vs '( ,'
sp_paren_comma                           = force    # ignore/add/remove/force

# Add or remove space before the variadic '...' when preceded by a non-punctuator
sp_before_ellipsis                       = ignore   # ignore/add/remove/force

# Add or remove space after class ':'
sp_after_class_colon                     = ignore   # ignore/add/remove/force

# Add or remove space before class ':'
sp_before_class_colon                    = ignore   # ignore/add/remove/force

# Add or remove space before case ':'. Default=Remove
sp_before_case_colon                     = remove   # ignore/add/remove/force

# Add or remove space between 'operator' and operator sign
sp_after_operator                        = ignore   # ignore/add/remove/force

# Add or remove space between the operator symbol and the open paren, as in 'operator ++('
sp_after_operator_sym                    = ignore   # ignore/add/remove/force

# Add or remove space after C/D cast, i.e. 'cast(int)a' vs 'cast(int) a' or '(int)a' vs '(int) a'
sp_after_cast                            = remove   # ignore/add/remove/force

# Add or remove spaces inside cast parens
sp_inside_paren_cast                     = remove   # ignore/add/remove/force

# Add or remove space between the type and open paren in a C++ cast, i.e. 'int(exp)' vs 'int (exp)'
sp_cpp_cast_paren                        = remove   # ignore/add/remove/force

# Add or remove space between 'sizeof' and '('
sp_sizeof_paren                          = remove   # ignore/add/remove/force

# Add or remove space after the tag keyword (Pawn)
sp_after_tag                             = ignore   # ignore/add/remove/force

# Add or remove space inside enum '{' and '}'
sp_inside_braces_enum                    = ignore   # ignore/add/remove/force

# Add or remove space inside struct/union '{' and '}'
sp_inside_braces_struct                  = ignore   # ignore/add/remove/force

# Add or remove space inside '{' and '}'
sp_inside_braces                         = ignore   # ignore/add/remove/force

# Add or remove space inside '{}'
sp_inside_braces_empty                   = ignore   # ignore/add/remove/force

# Add or remove space between return type and function name
# A minimum of 1 is forced except for pointer return types.
sp_type_func                             = force    # ignore/add/remove/force

# Add or remove space between function name and '(' on function declaration
sp_func_proto_paren                      = remove   # ignore/add/remove/force

# Add or remove space between function name and '(' on function definition
sp_func_def_paren                        = remove   # ignore/add/remove/force

# Add or remove space inside empty function '()'
sp_inside_fparens                        = ignore   # ignore/add/remove/force

# Add or remove space inside function '(' and ')'
sp_inside_fparen                         = ignore   # ignore/add/remove/force

# Add or remove space between ']' and '(' when part of a function call.
sp_square_fparen                         = ignore   # ignore/add/remove/force

# Add or remove space between ')' and '{' of function
sp_fparen_brace                          = ignore   # ignore/add/remove/force

# Add or remove space between function name and '(' on function calls
sp_func_call_paren                       = remove   # ignore/add/remove/force

# Add or remove space between function name and '()' on function calls without parameters.
# If set to 'ignore' (the default), sp_func_call_paren is used.
sp_func_call_paren_empty                 = remove   # ignore/add/remove/force

# Add or remove space between the user function name and '(' on function calls
# You need to set a keyword to be a user function, like this: 'set func_call_user _' in the config file.
sp_func_call_user_paren                  = ignore   # ignore/add/remove/force

# Add or remove space between a constructor/destructor and the open paren
sp_func_class_paren                      = ignore   # ignore/add/remove/force

# Add or remove space between 'return' and '('
sp_return_paren                          = ignore   # ignore/add/remove/force

# Add or remove space between '__attribute__' and '('
sp_attribute_paren                       = ignore   # ignore/add/remove/force

# Add or remove space between 'defined' and '(' in '#if defined (FOO)'
sp_defined_paren                         = force    # ignore/add/remove/force

# Add or remove space between 'throw' and '(' in 'throw (something)'
sp_throw_paren                           = ignore   # ignore/add/remove/force

# Add or remove space between 'catch' and '(' in 'catch (something) { }'
# If set to ignore, sp_before_sparen is used.
sp_catch_paren                           = ignore   # ignore/add/remove/force

# Add or remove space between 'version' and '(' in 'version (something) { }' (D language)
# If set to ignore, sp_before_sparen is used.
sp_version_paren                         = remove   # ignore/add/remove/force

# Add or remove space between 'scope' and '(' in 'scope (something) { }' (D language)
# If set to ignore, sp_before_sparen is used.
sp_scope_paren                           = remove   # ignore/add/remove/force

# Add or remove space between macro and value
sp_macro                                 = ignore   # ignore/add/remove/force

# Add or remove space between macro function ')' and value
sp_macro_func                            = ignore   # ignore/add/remove/force

# Add or remove space between 'else' and '{' if on the same line
sp_else_brace                            = ignore   # ignore/add/remove/force

# Add or remove space between '}' and 'else' if on the same line
sp_brace_else                            = ignore   # ignore/add/remove/force

# Add or remove space between '}' and the name of a typedef on the same line
sp_brace_typedef                         = force    # ignore/add/remove/force

# Add or remove space between 'catch' and '{' if on the same line
sp_catch_brace                           = ignore   # ignore/add/remove/force

# Add or remove space between '}' and 'catch' if on the same line
sp_brace_catch                           = ignore   # ignore/add/remove/force

# Add or remove space between 'finally' and '{' if on the same line
sp_finally_brace                         = ignore   # ignore/add/remove/force

# Add or remove space between '}' and 'finally' if on the same line
sp_brace_finally                         = ignore   # ignore/add/remove/force

# Add or remove space between 'try' and '{' if on the same line
sp_try_brace                             = ignore   # ignore/add/remove/force

# Add or remove space between get/set and '{' if on the same line
sp_getset_brace                          = ignore   # ignore/add/remove/force

# Add or remove space before the '::' operator
sp_before_dc                             = ignore   # ignore/add/remove/force

# Add or remove space after the '::' operator
sp_after_dc                              = ignore   # ignore/add/remove/force

# Add or remove around the D named array initializer ':' operator
sp_d_array_colon                         = ignore   # ignore/add/remove/force

# Add or remove space after the '!' (not) operator. Default=Remove
sp_not                                   = remove   # ignore/add/remove/force

# Add or remove space after the '~' (invert) operator. Default=Remove
sp_inv                                   = remove   # ignore/add/remove/force

# Add or remove space after the '&' (address-of) operator. Default=Remove
# This does not affect the spacing after a '&' that is part of a type.
sp_addr                                  = remove   # ignore/add/remove/force

# Add or remove space around the '.' or '->' operators. Default=Remove
sp_member                                = remove   # ignore/add/remove/force

# Add or remove space after the '*' (dereference) operator. Default=Remove
# This does not affect the spacing after a '*' that is part of a type.
sp_deref                                 = remove   # ignore/add/remove/force

# Add or remove space after '+' or '-', as in 'x = -5' or 'y = +7'. Default=Remove
sp_sign                                  = remove   # ignore/add/remove/force

# Add or remove space before or after '++' and '--', as in '(--x)' or 'y++;'. Default=Remove
sp_incdec                                = remove   # ignore/add/remove/force

# Add or remove space before a backslash-newline at the end of a line. Default=Add
sp_before_nl_cont                        = add      # ignore/add/remove/force

# Add or remove space after the scope '+' or '-', as in '-(void) foo;' or '+(int) bar;'
sp_after_oc_scope                        = add      # ignore/add/remove/force

# Add or remove space after the colon in message specs
# '-(int) f:(int) x;' vs '-(int) f: (int) x;'
sp_after_oc_colon                        = remove   # ignore/add/remove/force

# Add or remove space before the colon in message specs
# '-(int) f: (int) x;' vs '-(int) f : (int) x;'
sp_before_oc_colon                       = remove   # ignore/add/remove/force

# Add or remove space after the colon in message specs
# '[object setValue:1];' vs '[object setValue: 1];'
sp_after_send_oc_colon                   = remove   # ignore/add/remove/force

# Add or remove space before the colon in message specs
# '[object setValue:1];' vs '[object setValue :1];'
sp_before_send_oc_colon                  = remove   # ignore/add/remove/force

# Add or remove space after the (type) in message specs
# '-(int)f: (int) x;' vs '-(int)f: (int)x;'
sp_after_oc_type                         = remove   # ignore/add/remove/force

# Add or remove space after the first (type) in message specs
# '-(int) f:(int)x;' vs '-(int)f:(int)x;'
sp_after_oc_return_type                  = add      # ignore/add/remove/force

# Add or remove space between '@selector' and '('
# '@selector(msgName)' vs '@selector (msgName)'
# Also applies to @protocol() constructs
sp_after_oc_at_sel                       = remove   # ignore/add/remove/force

# Add or remove space between '@selector(x)' and the following word
# '@selector(foo) a:' vs '@selector(foo)a:'
sp_after_oc_at_sel_parens                = add      # ignore/add/remove/force

# Add or remove space inside '@selector' parens
# '@selector(foo)' vs '@selector( foo )'
# Also applies to @protocol() constructs
sp_inside_oc_at_sel_parens               = remove   # ignore/add/remove/force

# Add or remove space before a block pointer caret
# '^int (int arg){...}' vs. ' ^int (int arg){...}'
sp_before_oc_block_caret                 = add      # ignore/add/remove/force

# Add or remove space after a block pointer caret
# '^int (int arg){...}' vs. '^ int (int arg){...}'
sp_after_oc_block_caret                  = remove   # ignore/add/remove/force

# Add or remove space around the ':' in 'b ? t : f'
sp_cond_colon                            = add      # ignore/add/remove/force

# Add or remove space around the '?' in 'b ? t : f'
sp_cond_question                         = add      # ignore/add/remove/force

# Fix the spacing between 'case' and the label. Only 'ignore' and 'force' make sense here.
sp_case_label                            = force    # ignore/add/remove/force

# Control the space around the D '..' operator.
sp_range                                 = ignore   # ignore/add/remove/force

# Control the space after the opening of a C++ comment '// A' vs '//A'
sp_cmt_cpp_start                         = ignore   # ignore/add/remove/force

# Controls the spaces between #else or #endif and a trailing comment
sp_endif_cmt                             = force    # ignore/add/remove/force

# Controls the spaces after 'new', 'delete', and 'delete[]'
sp_after_new                             = force    # ignore/add/remove/force

# Controls the spaces before a trailing or embedded comment
sp_before_tr_emb_cmt                     = ignore   # ignore/add/remove/force

# Number of spaces before a trailing or embedded comment
sp_num_before_tr_emb_cmt                 = 0        # number

#
# Code alignment (not left column spaces/tabs)
#

# Whether to keep non-indenting tabs
align_keep_tabs                          = false    # false/true

# Whether to use tabs for aligning
align_with_tabs                          = false    # false/true

# Whether to bump out to the next tab when aligning
align_on_tabstop                         = false    # false/true

# Whether to left-align numbers
align_number_left                        = true     # false/true

# Align variable definitions in prototypes and functions
align_func_params                        = false    # false/true

# Align parameters in single-line functions that have the same name.
# The function names must already be aligned with each other.
align_same_func_call_params              = false    # false/true

# The span for aligning variable definitions (0=don't align)
align_var_def_span                       = 0        # number

# How to align the star in variable definitions.
#  0=Part of the type     'void *   foo;'
#  1=Part of the variable 'void     *foo;'
#  2=Dangling             'void    *foo;'
align_var_def_star_style                 = 2        # number

# How to align the '&' in variable definitions.
#  0=Part of the type
#  1=Part of the variable
#  2=Dangling
align_var_def_amp_style                  = 2        # number

# The threshold for aligning variable definitions (0=no limit)
align_var_def_thresh                     = 0        # number

# The gap for aligning variable definitions
align_var_def_gap                        = 0        # number

# Whether to align the colon in struct bit fields
align_var_def_colon                      = false    # false/true

# Whether to align any attribute after the variable name
align_var_def_attribute                  = false    # false/true

# Whether to align inline struct/enum/union variable definitions
align_var_def_inline                     = false    # false/true

# The span for aligning on '=' in assignments (0=don't align)
align_assign_span                        = 0        # number

# The threshold for aligning on '=' in assignments (0=no limit)
align_assign_thresh                      = 0        # number

# The span for aligning on '=' in enums (0=don't align)
align_enum_equ_span                      = 1        # number

# The threshold for aligning on '=' in enums (0=no limit)
align_enum_equ_thresh                    = 1        # number

# The span for aligning struct/union (0=don't align)
align_var_struct_span                    = 1        # number

# The threshold for aligning struct/union member definitions (0=no limit)
align_var_struct_thresh                  = 0        # number

# The gap for aligning struct/union member definitions
align_var_struct_gap                     = 0        # number

# The span for aligning struct initializer values (0=don't align)
align_struct_init_span                   = 1        # number

# The minimum space between the type and the synonym of a typedef
align_typedef_gap                        = 0        # number

# The span for aligning single-line typedefs (0=don't align)
align_typedef_span                       = 0        # number

# How to align typedef'd functions with other typedefs
# 0: Don't mix them at all
# 1: align the open paren with the types
# 2: align the function type name with the other type names
align_typedef_func                       = 0        # number

# Controls the positioning of the '*' in typedefs. Just try it.
# 0: Align on typedef type, ignore '*'
# 1: The '*' is part of type name: typedef int  *pint;
# 2: The '*' is part of the type, but dangling: typedef int *pint;
align_typedef_star_style                 = 2        # number

# Controls the positioning of the '&' in typedefs. Just try it.
# 0: Align on typedef type, ignore '&'
# 1: The '&' is part of type name: typedef int  &pint;
# 2: The '&' is part of the type, but dangling: typedef int &pint;
align_typedef_amp_style                  = 2        # number

# The span for aligning comments that end lines (0=don't align)
align_right_cmt_span                     = 0        # number

# If aligning comments, mix with comments after '}' and #endif with less than 3 spaces before the comment
align_right_cmt_mix                      = false    # false/true

# If a trailing comment is more than this number of columns away from the text it follows,
# it will qualify for being aligned. This has to be > 0 to do anything.
align_right_cmt_gap                      = 0        # number

# Align trailing comment at or beyond column N; 'pulls in' comments as a bonus side effect (0=ignore)
align_right_cmt_at_col                   = 0        # number

# The span for aligning function prototypes (0=don't align)
align_func_proto_span                    = 0        # number

# Minimum gap between the return type and the function name.
align_func_proto_gap                     = 0        # number

# Align function protos on the 'operator' keyword instead of what follows
align_on_operator                        = false    # false/true

# Whether to mix aligning prototype and variable declarations.
# If true, align_var_def_XXX options are used instead of align_func_proto_XXX options.
align_mix_var_proto                      = false    # false/true

# Align single-line functions with function prototypes, uses align_func_proto_span
align_single_line_func                   = false    # false/true

# Aligning the open brace of single-line functions.
# Requires align_single_line_func=true, uses align_func_proto_span
align_single_line_brace                  = false    # false/true

# Gap for align_single_line_brace.
align_single_line_brace_gap              = 0        # number

# The span for aligning ObjC msg spec (0=don't align)
align_oc_msg_spec_span                   = 0        # number

# Whether to align macros wrapped with a backslash and a newline.
# This will not work right if the macro contains a multi-line comment.
align_nl_cont                            = true     # false/true

# The minimum space between label and value of a preprocessor define
align_pp_define_gap                      = 0        # number

# The span for aligning on '#define' bodies (0=don't align)
align_pp_define_span                     = 0        # number

# Align lines that start with '<<' with previous '<<'. Default=true
align_left_shift                         = true     # false/true

# Span for aligning parameters in an Obj-C message call on the ':' (0=don't align)
align_oc_msg_colon_span                  = 1       # number

# Aligning parameters in an Obj-C '+' or '-' declaration on the ':'
align_oc_decl_colon                      = true     # false/true

#
# Newline adding and removing options
#

# Whether to collapse empty blocks between '{' and '}'
nl_collapse_empty_body                   = false    # false/true

# Don't split one-line braced assignments - 'foo_t f = { 1, 2 };'
nl_assign_leave_one_liners               = false    # false/true

# Don't split one-line braced statements inside a class xx { } body
nl_class_leave_one_liners                = false    # false/true

# Don't split one-line enums: 'enum foo { BAR = 15 };'
nl_enum_leave_one_liners                 = false    # false/true

# Don't split one-line get or set functions
nl_getset_leave_one_liners               = false    # false/true

# Don't split one-line function definitions - 'int foo() { return 0; }'
nl_func_leave_one_liners                 = false    # false/true

# Don't split one-line if/else statements - 'if(a) b++;'
nl_if_leave_one_liners                   = false    # false/true

# Add or remove newlines at the start of the file
nl_start_of_file                         = ignore   # ignore/add/remove/force

# The number of newlines at the start of the file (only used if nl_start_of_file is 'add' or 'force'
nl_start_of_file_min                     = 0        # number

# Add or remove newline at the end of the file
nl_end_of_file                           = force    # ignore/add/remove/force

# The number of newlines at the end of the file (only used if nl_end_of_file is 'add' or 'force')
nl_end_of_file_min                       = 1        # number

# Add or remove newline between '=' and '{'
nl_assign_brace                          = ignore   # ignore/add/remove/force

# Add or remove newline between '=' and '[' (D only)
nl_assign_square                         = ignore   # ignore/add/remove/force

# Add or remove newline after '= [' (D only). Will also affect the newline before the ']'
nl_after_square_assign                   = ignore   # ignore/add/remove/force

# The number of blank lines after a block of variable definitions at the top of a function body.
# 0=no change (default)
nl_func_var_def_blk                      = 0        # number

# Add or remove newline between a function call's ')' and '{', as in:
# list_for_each(item, &list) { }
nl_fcall_brace                           = force    # ignore/add/remove/force

# Add or remove newline between 'enum' and '{'
nl_enum_brace                            = remove   # ignore/add/remove/force

# Add or remove newline between 'struct and '{'
nl_struct_brace                          = remove   # ignore/add/remove/force

# Add or remove newline between 'union' and '{'
nl_union_brace                           = remove   # ignore/add/remove/force

# Add or remove newline between 'if' and '{'
nl_if_brace                              = force    # ignore/add/remove/force

# Add or remove newline between '}' and 'else'
nl_brace_else                            = force    # ignore/add/remove/force

# Add or remove newline between 'else if' and '{'
# If set to ignore, nl_if_brace is used instead
nl_elseif_brace                          = force    # ignore/add/remove/force

# Add or remove newline between 'else' and '{'
nl_else_brace                            = force    # ignore/add/remove/force

# Add or remove newline between 'else' and 'if'
nl_else_if                               = remove   # ignore/add/remove/force

# Add or remove newline between '}' and 'finally'
nl_brace_finally                         = force    # ignore/add/remove/force

# Add or remove newline between 'finally' and '{'
nl_finally_brace                         = force    # ignore/add/remove/force

# Add or remove newline between 'try' and '{'
nl_try_brace                             = force    # ignore/add/remove/force

# Add or remove newline between get/set and '{'
nl_getset_brace                          = force    # ignore/add/remove/force

# Add or remove newline between 'for' and '{'
nl_for_brace                             = force    # ignore/add/remove/force

# Add or remove newline between 'catch' and '{'
nl_catch_brace                           = force    # ignore/add/remove/force

# Add or remove newline between '}' and 'catch'
nl_brace_catch                           = force    # ignore/add/remove/force

# Add or remove newline between 'while' and '{'
nl_while_brace                           = force    # ignore/add/remove/force

# Add or remove newline between 'using' and '{'
nl_using_brace                           = force    # ignore/add/remove/force

# Add or remove newline between two open or close braces.
# Due to general newline/brace handling, REMOVE may not work.
nl_brace_brace                           = force    # ignore/add/remove/force

# Add or remove newline between 'do' and '{'
nl_do_brace                              = force    # ignore/add/remove/force

# Add or remove newline between '}' and 'while' of 'do' statement
nl_brace_while                           = force    # ignore/add/remove/force

# Add or remove newline between 'switch' and '{'
nl_switch_brace                          = force    # ignore/add/remove/force

# Add a newline between ')' and '{' if the ')' is on a different line than the if/for/etc.
# Overrides nl_for_brace, nl_if_brace, nl_switch_brace, nl_while_switch, and nl_catch_brace.
nl_multi_line_cond                       = true     # false/true

# Force a newline in a define after the macro name for multi-line defines.
nl_multi_line_define                     = true     # false/true

# Whether to put a newline before 'case' statement
nl_before_case                           = false    # false/true

# Add or remove newline between ')' and 'throw'
nl_before_throw                          = ignore   # ignore/add/remove/force

# Whether to put a newline after 'case' statement
nl_after_case                            = true     # false/true

# Add or remove a newline between a case ':' and '{'. Overrides nl_after_case.
nl_case_colon_brace                      = ignore   # ignore/add/remove/force

# Newline between namespace and {
nl_namespace_brace                       = ignore   # ignore/add/remove/force

# Add or remove newline between 'template<>' and whatever follows.
nl_template_class                        = ignore   # ignore/add/remove/force

# Add or remove newline between 'class' and '{'
nl_class_brace                           = force   # ignore/add/remove/force

# Add or remove newline after each ',' in the constructor member initialization
nl_class_init_args                       = ignore   # ignore/add/remove/force

# Add or remove newline between return type and function name in a function definition
nl_func_type_name                        = ignore   # ignore/add/remove/force

# Add or remove newline between return type and function name inside a class {}
# Uses nl_func_type_name or nl_func_proto_type_name if set to ignore.
nl_func_type_name_class                  = ignore   # ignore/add/remove/force

# Add or remove newline between function scope and name in a definition
# Controls the newline after '::' in 'void A::f() { }'
nl_func_scope_name                       = ignore   # ignore/add/remove/force

# Add or remove newline between return type and function name in a prototype
nl_func_proto_type_name                  = ignore   # ignore/add/remove/force

# Add or remove newline between a function name and the opening '('
nl_func_paren                            = ignore   # ignore/add/remove/force

# Add or remove newline between a function name and the opening '(' in the definition
nl_func_def_paren                        = ignore   # ignore/add/remove/force

# Add or remove newline after '(' in a function declaration
nl_func_decl_start                       = ignore   # ignore/add/remove/force

# Add or remove newline after '(' in a function definition
nl_func_def_start                        = ignore   # ignore/add/remove/force

# Overrides nl_func_decl_start when there is only one parameter.
nl_func_decl_start_single                = ignore   # ignore/add/remove/force

# Overrides nl_func_def_start when there is only one parameter.
nl_func_def_start_single                 = ignore   # ignore/add/remove/force

# Add or remove newline after each ',' in a function declaration
nl_func_decl_args                        = ignore   # ignore/add/remove/force

# Add or remove newline after each ',' in a function definition
nl_func_def_args                         = ignore   # ignore/add/remove/force

# Add or remove newline before the ')' in a function declaration
nl_func_decl_end                         = ignore   # ignore/add/remove/force

# Add or remove newline before the ')' in a function definition
nl_func_def_end                          = ignore   # ignore/add/remove/force

# Overrides nl_func_decl_end when there is only one parameter.
nl_func_decl_end_single                  = ignore   # ignore/add/remove/force

# Overrides nl_func_def_end when there is only one parameter.
nl_func_def_end_single                   = ignore   # ignore/add/remove/force

# Add or remove newline between '()' in a function declaration.
nl_func_decl_empty                       = ignore   # ignore/add/remove/force

# Add or remove newline between '()' in a function definition.
nl_func_def_empty                        = ignore   # ignore/add/remove/force

# Add or remove newline between function signature and '{'
nl_fdef_brace                            = force    # ignore/add/remove/force

# Whether to put a newline after 'return' statement
nl_after_return                          = false    # false/true

# Add or remove a newline between the return keyword and return expression.
nl_return_expr                           = ignore   # ignore/add/remove/force

# Whether to put a newline after semicolons, except in 'for' statements
nl_after_semicolon                       = false    # false/true

# Whether to put a newline after brace open.
# This also adds a newline before the matching brace close.
nl_after_brace_open                      = false    # false/true

# If nl_after_brace_open and nl_after_brace_open_cmt are true, a newline is
# placed between the open brace and a trailing single-line comment.
nl_after_brace_open_cmt                  = false    # false/true

# Whether to put a newline after a virtual brace open with a non-empty body.
# These occur in un-braced if/while/do/for statement bodies.
nl_after_vbrace_open                     = false    # false/true

# Whether to put a newline after a virtual brace open with an empty body.
# These occur in un-braced if/while/do/for statement bodies.
nl_after_vbrace_open_empty               = false    # false/true

# Whether to put a newline after a brace close.
# Does not apply if followed by a necessary ';'.
nl_after_brace_close                     = true     # false/true

# Whether to put a newline after a virtual brace close.
# Would add a newline before return in: 'if (foo) a++; return;'
nl_after_vbrace_close                    = false    # false/true

# Whether to alter newlines in '#define' macros
nl_define_macro                          = false    # false/true

# Whether to not put blanks after '#ifxx', '#elxx', or before '#endif'
nl_squeeze_ifdef                         = true     # false/true

# Add or remove blank line before 'if'
nl_before_if                             = ignore   # ignore/add/remove/force

# Add or remove blank line after 'if' statement
nl_after_if                              = force    # ignore/add/remove/force

# Add or remove blank line before 'for'
nl_before_for                            = ignore   # ignore/add/remove/force

# Add or remove blank line after 'for' statement
nl_after_for                             = force    # ignore/add/remove/force

# Add or remove blank line before 'while'
nl_before_while                          = ignore   # ignore/add/remove/force

# Add or remove blank line after 'while' statement
nl_after_while                           = force    # ignore/add/remove/force

# Add or remove blank line before 'switch'
nl_before_switch                         = ignore   # ignore/add/remove/force

# Add or remove blank line after 'switch' statement
nl_after_switch                          = force    # ignore/add/remove/force

# Add or remove blank line before 'do'
nl_before_do                             = ignore   # ignore/add/remove/force

# Add or remove blank line after 'do/while' statement
nl_after_do                              = force    # ignore/add/remove/force

# Whether to double-space commented-entries in struct/enum
nl_ds_struct_enum_cmt                    = false    # false/true

# Whether to double-space before the close brace of a struct/union/enum
# (lower priority than 'eat_blanks_before_close_brace')
nl_ds_struct_enum_close_brace            = false    # false/true

# Add or remove a newline around a class colon.
# Related to pos_class_colon, nl_class_init_args, and pos_comma.
nl_class_colon                           = ignore   # ignore/add/remove/force

# Change simple unbraced if statements into a one-liner
# 'if(b)\n i++;' => 'if(b) i++;'
nl_create_if_one_liner                   = true     # false/true

# Change simple unbraced for statements into a one-liner
# 'for (i=0;i<5;i++)\n foo(i);' => 'for (i=0;i<5;i++) foo(i);'
nl_create_for_one_liner                  = true     # false/true

# Change simple unbraced while statements into a one-liner
# 'while (i<5)\n foo(i++);' => 'while (i<5) foo(i++);'
nl_create_while_one_liner                = true     # false/true

#
# Positioning options
#

# The position of arithmetic operators in wrapped expressions
pos_arith                                = ignore   # ignore/lead/lead_break/lead_force/trail/trail_break/trail_force

# The position of assignment in wrapped expressions.
# Do not affect '=' followed by '{'
pos_assign                               = ignore   # ignore/lead/lead_break/lead_force/trail/trail_break/trail_force

# The position of boolean operators in wrapped expressions
pos_bool                                 = ignore   # ignore/lead/lead_break/lead_force/trail/trail_break/trail_force

# The position of comparison operators in wrapped expressions
pos_compare                              = ignore   # ignore/lead/lead_break/lead_force/trail/trail_break/trail_force

# The position of conditional (b ? t : f) operators in wrapped expressions
pos_conditional                          = ignore   # ignore/lead/lead_break/lead_force/trail/trail_break/trail_force

# The position of the comma in wrapped expressions
pos_comma                                = ignore   # ignore/lead/lead_break/lead_force/trail/trail_break/trail_force

# The position of the comma in the constructor initialization list
pos_class_comma                          = ignore   # ignore/lead/lead_break/lead_force/trail/trail_break/trail_force

# The position of colons between constructor and member initialization
pos_class_colon                          = ignore   # ignore/lead/lead_break/lead_force/trail/trail_break/trail_force

#
# Line Splitting options
#

# Try to limit code width to N number of columns
code_width                               = 0        # number

# Whether to fully split long 'for' statements at semi-colons
ls_for_split_full                        = false    # false/true

# Whether to fully split long function protos/calls at commas
ls_func_split_full                       = false    # false/true

#
# Blank line options
#

# The maximum consecutive newlines
nl_max                                   = 2        # number

# The number of newlines after a function prototype, if followed by another function prototype
nl_after_func_proto                      = 0        # number

# The number of newlines after a function prototype, if not followed by another function prototype
nl_after_func_proto_group                = 1        # number

# The number of newlines after '}' of a multi-line function body
nl_after_func_body                       = 3        # number

# The number of newlines after '}' of a multi-line function body in a class declaration
nl_after_func_body_class                 = 0        # number

# The number of newlines after '}' of a single line function body
nl_after_func_body_one_liner             = 0        # number

# The minimum number of newlines before a multi-line comment.
# Doesn't apply if after a brace open or another multi-line comment.
nl_before_block_comment                  = 0        # number

# The minimum number of newlines before a single-line C comment.
# Doesn't apply if after a brace open or other single-line C comments.
nl_before_c_comment                      = 0        # number

# The minimum number of newlines before a CPP comment.
# Doesn't apply if after a brace open or other CPP comments.
nl_before_cpp_comment                    = 0        # number

# Whether to force a newline after a multi-line comment.
nl_after_multiline_comment               = false    # false/true

# The number of newlines after '}' or ';' of a struct/enum/union definition
nl_after_struct                          = 0        # number

# The number of newlines after '}' or ';' of a class definition
nl_after_class                           = 0        # number

# The number of newlines before a 'private:', 'public:', 'protected:', 'signals:', or 'slots:' label.
# Will not change the newline count if after a brace open.
# 0 = No change.
nl_before_access_spec                    = 0        # number

# The number of newlines after a 'private:', 'public:', 'protected:', 'signals:', or 'slots:' label.
# 0 = No change.
nl_after_access_spec                     = 0        # number

# The number of newlines between a function def and the function comment.
# 0 = No change.
nl_comment_func_def                      = 1        # number

# The number of newlines after a try-catch-finally block that isn't followed by a brace close.
# 0 = No change.
nl_after_try_catch_finally               = 2        # number

# The number of newlines before and after a property, indexer or event decl.
# 0 = No change.
nl_around_cs_property                    = 0        # number

# The number of newlines between the get/set/add/remove handlers in C#.
# 0 = No change.
nl_between_get_set                       = 0        # number

# Add or remove newline between C# property and the '{'
nl_property_brace                        = ignore   # ignore/add/remove/force

# Whether to remove blank lines after '{'
eat_blanks_after_open_brace              = true     # false/true

# Whether to remove blank lines before '}'
eat_blanks_before_close_brace            = true     # false/true

#
# Code modifying options (non-whitespace)
#

# Add or remove braces on single-line 'do' statement
mod_full_brace_do                        = add      # ignore/add/remove/force

# Add or remove braces on single-line 'for' statement
mod_full_brace_for                       = add      # ignore/add/remove/force

# Add or remove braces on single-line function definitions. (Pawn)
mod_full_brace_function                  = add      # ignore/add/remove/force

# Add or remove braces on single-line 'if' statement. Will not remove the braces if they contain an 'else'.
mod_full_brace_if                        = add      # ignore/add/remove/force

# Make all if/elseif/else statements in a chain be braced or not. Overrides mod_full_brace_if.
# If any must be braced, they are all braced.  If all can be unbraced, then the braces are removed.
mod_full_brace_if_chain                  = false    # false/true

# Don't remove braces around statements that span N newlines
mod_full_brace_nl                        = 0        # number

# Add or remove braces on single-line 'while' statement
mod_full_brace_while                     = add      # ignore/add/remove/force

# Add or remove braces on single-line 'using ()' statement
mod_full_brace_using                     = ignore   # ignore/add/remove/force

# Add or remove unnecessary paren on 'return' statement
mod_paren_on_return                      = ignore   # ignore/add/remove/force

# Whether to change optional semicolons to real semicolons
mod_pawn_semicolon                       = false    # false/true

# Add parens on 'while' and 'if' statement around bools
mod_full_paren_if_bool                   = false    # false/true

# Whether to remove superfluous semicolons
mod_remove_extra_semicolon               = true     # false/true

# If a function body exceeds the specified number of newlines and doesn't have a comment after
# the close brace, a comment will be added.
mod_add_long_function_closebrace_comment = 0        # number

# If a switch body exceeds the specified number of newlines and doesn't have a comment after
# the close brace, a comment will be added.
mod_add_long_switch_closebrace_comment   = 15       # number

# If an #ifdef body exceeds the specified number of newlines and doesn't have a comment after
# the #endif, a comment will be added.
mod_add_long_ifdef_endif_comment         = 5        # number

# If an #ifdef or #else body exceeds the specified number of newlines and doesn't have a comment after
# the #else, a comment will be added.
mod_add_long_ifdef_else_comment          = 5        # number

# If TRUE, will sort consecutive single-line 'import' statements [Java, D]
mod_sort_import                          = false    # false/true

# If TRUE, will sort consecutive single-line 'using' statements [C#]
mod_sort_using                           = false    # false/true

# If TRUE, will sort consecutive single-line '#include' statements [C/C++] and '#import' statements [Obj-C]
# This is generally a bad idea, as it may break your code.
mod_sort_include                         = false    # false/true

# If TRUE, it will move a 'break' that appears after a fully braced 'case' before the close brace.
mod_move_case_break                      = false    # false/true

# Will add or remove the braces around a fully braced case statement.
# Will only remove the braces if there are no variable declarations in the block.
mod_case_brace                           = ignore   # ignore/add/remove/force

# If TRUE, it will remove a void 'return;' that appears as the last statement in a function.
mod_remove_empty_return                  = false    # false/true

#
# Comment modifications
#

# Try to wrap comments at cmt_width columns
cmt_width                                = 0        # number

# Set the comment reflow mode (default: 0)
# 0: no reflowing (apart from the line wrapping due to cmt_width)
# 1: no touching at all
# 2: full reflow
cmt_reflow_mode                          = 0        # number

# If false, disable all multi-line comment changes, including cmt_width. keyword substitution, and leading chars.
# Default is true.
cmt_indent_multi                         = true     # false/true

# Whether to group c-comments that look like they are in a block
cmt_c_group                              = true     # false/true

# Whether to put an empty '/*' on the first line of the combined c-comment
cmt_c_nl_start                           = true     # false/true

# Whether to put a newline before the closing '*/' of the combined c-comment
cmt_c_nl_end                             = true     # false/true

# Whether to group cpp-comments that look like they are in a block
cmt_cpp_group                            = true     # false/true

# Whether to put an empty '/*' on the first line of the combined cpp-comment
cmt_cpp_nl_start                         = false    # false/true

# Whether to put a newline before the closing '*/' of the combined cpp-comment
cmt_cpp_nl_end                           = true     # false/true

# Whether to change cpp-comments into c-comments
cmt_cpp_to_c                             = false    # false/true

# Whether to put a star on subsequent comment lines
cmt_star_cont                            = false    # false/true

# The number of spaces to insert at the start of subsequent comment lines
cmt_sp_before_star_cont                  = 0        # number

# The number of spaces to insert after the star on subsequent comment lines
cmt_sp_after_star_cont                   = 0        # number

# For multi-line comments with a '*' lead, remove leading spaces if the first and last lines of
# the comment are the same length. Default=True
cmt_multi_check_last                     = true     # false/true

# The filename that contains text to insert at the head of a file if the file doesn't start with a C/C++ comment.
# Will substitute $(filename) with the current file's name.
cmt_insert_file_header                   = ""         # string

# The filename that contains text to insert at the end of a file if the file doesn't end with a C/C++ comment.
# Will substitute $(filename) with the current file's name.
cmt_insert_file_footer                   = ""         # string

# The filename that contains text to insert before a function implementation if the function isn't preceded with a C/C++ comment.
# Will substitute $(function) with the function name and $(javaparam) with the javadoc @param and @return stuff.
# Will also substitute $(fclass) with the class name: void CFoo::Bar() { ... }
cmt_insert_func_header                   = ""         # string

# The filename that contains text to insert before a class if the class isn't preceded with a C/C++ comment.
# Will substitute $(class) with the class name.
cmt_insert_class_header                  = ""         # string

# The filename that contains text to insert before a Obj-C message specification if the method isn't preceeded with a C/C++ comment.
# Will substitute $(message) with the function name and $(javaparam) with the javadoc @param and @return stuff.
cmt_insert_oc_msg_header                 = ""         # string

# If a preprocessor is encountered when stepping backwards from a function name, then
# this option decides whether the comment should be inserted.
# Affects cmt_insert_oc_msg_header, cmt_insert_func_header and cmt_insert_class_header.
cmt_insert_before_preproc                = false    # false/true

#
# Preprocessor options
#

# Control indent of preprocessors inside #if blocks at brace level 0
pp_indent                                = force    # ignore/add/remove/force

# Whether to indent #if/#else/#endif at the brace level (true) or from column 1 (false)
pp_indent_at_level                       = false    # false/true

# If pp_indent_at_level=false, specifies the number of columns to indent per level. Default=1.
pp_indent_count                          = 0        # number

# Add or remove space after # based on pp_level of #if blocks
pp_space                                 = add      # ignore/add/remove/force

# Sets the number of spaces added with pp_space
pp_space_count                           = 2        # number

# The indent for #region and #endregion in C# and '#pragma region' in C/C++
pp_indent_region                         = 0        # number

# Whether to indent the code between #region and #endregion
pp_region_indent_code                    = true     # false/true

# If pp_indent_at_level=true, sets the indent for #if, #else, and #endif when not at file-level
pp_indent_if                             = 0        # number

# Control whether to indent the code between #if, #else and #endif when not at file-level
pp_if_indent_code                        = false    # false/true

# Whether to indent '#define' at the brace level (true) or from column 1 (false)
pp_define_at_level                       = true     # false/true

# You can force a token to be a type with the 'type' option.
# Example:
# type myfoo1 myfoo2
#
# You can create custom macro-based indentation using macro-open,
# macro-else and macro-close.
# Example:
# macro-open  BEGIN_TEMPLATE_MESSAGE_MAP
# macro-open  BEGIN_MESSAGE_MAP
# macro-close END_MESSAGE_MAP
#
# You can assign any keyword to any type with the set option.
# set func_call_user _ N_
#
# The full syntax description of all custom definition config entries
# is shown below:
#
# define custom tokens as:
# - embed whitespace in token using '' escape character, or
#   put token in quotes
# - these: ' " and ` are recognized as quote delimiters
#
# type token1 token2 token3 ...
#             ^ optionally specify multiple tokens on a single line
# define def_token output_token
#                  ^ output_token is optional, then NULL is assumed
# macro-open token
# macro-close token
# macro-else token
# set id token1 token2 ...
#               ^ optionally specify multiple tokens on a single line
#     ^ id is one of the names in token_enum.h sans the CT_ prefix,
#       e.g. PP_PRAGMA
#
# all tokens are separated by any mix of ',' commas, '=' equal signs
# and whitespace (space, tab)
#