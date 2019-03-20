"""
Week 4 practice project template for Python Data Representation
Update syntax for print in CodeSkulptor Docs
from "print ..." syntax in Python 2 to "print(...)" syntax for Python 3
"""

# HTML tags that bounds example code
PREFIX = "<pre class='cm'>"
POSTFIX = "</pre>"
PRINT = "print"

def split_string(string_to_split, separator, method):
    """
        Takes a string representing a single line of code and a separator line
        and split the string and join it to form a new string
    """
    list_string = string_to_split.split(separator)
    for string in list_string:
        index_str = list_string.index(string)
        if method == "update_line":
            list_string.insert(index_str, update_line(string))
        else:
            list_string.insert(index_str, update_pre_block(string))
        list_string.remove(string)
    list_string = separator.join(list_string)
    return list_string

def update_line(line):
    """
    Takes a string line representing a single line of code
    and returns a string with print updated
    """

    # Strip left white space using built-in string method lstrip()
    # If line is print statement,  use the format() method to add insert parentheses
    # Note that solution does not handle white space/comments after print statememt
    if PRINT in line:
        start_idx = line.find(PRINT)
        end_idx = start_idx + len(PRINT)
        return (line[0:end_idx]+"{0}"+line[end_idx:].lstrip()+"{1}").format("(", ")")

    return line


# Some simple tests
# print(update_line(""))
# print(update_line("foobar()"))
# print(update_line("print 1 + 1"))
# print(update_line("    print 2, 3, 4"))


# Expect output
##
##foobar()
##print(1 + 1)
##    print(2, 3, 4)


def update_pre_block(pre_block):
    """
    Take a string that correspond to a <pre> block in html and parses it into lines.
    Returns string corresponding to updated <pre> block with each line
    updated via process_line()
    """
    updated_block = pre_block
    if POSTFIX in pre_block:
        updated_block = split_string(pre_block, POSTFIX, "update_line")

    return updated_block


# Some simple tests
# print(update_pre_block(""))
# print(update_pre_block("foobar()"))
# print(update_pre_block("if foo():\n    bar()"))
# print(update_pre_block("print\nprint 1+1\nprint 2, 3, 4"))
# print(update_pre_block("    print a + b\n    print 23 * 34\n        print 1234"))


# Expected output
##
##foobar()
##if foo():
##    bar()
##print()
##print(1+1)
##print(2, 3, 4)
##    print(a + b)
##    print(23 * 34)
##        print(1234)

def update_file(input_file_name, output_file_name):
    """
    Open and read the file specified by the string input_file_name
    Proces the <pre> blocks in the loaded text to update print syntax)
    Write the update text to the file specified by the string output_file_name
    """

    # open file and read text in file as a string
    open_input_file = open(input_file_name, "rt")
    input_string = open_input_file.read()
    # split text in <pre> blocks and update using update_pre_block()
    list_text = split_string(input_string, PREFIX, "update_pre_block")
    # Write the answer in the specified output file
    open_output_file = open(output_file_name, "wt")
    open_output_file.write(list_text)
    # Close input and output files
    open_input_file.close()
    open_output_file.close()


# A couple of test files
update_file("table.html", "table_updated.html")
update_file("docs.html", "docs_updated.html")

# Import some code to check whether the computed files are correct
##import examples3_file_diff as file_diff
##file_diff.compare_files("table_updated.html", "table_updated_solution.html")
##file_diff.compare_files("docs_updated.html", "docs_updated_solution.html")

# Expected output
##table_updated.html and table_updated_solution.html are the same
##docs_updated.html and docs_updated_solution.html are the same
