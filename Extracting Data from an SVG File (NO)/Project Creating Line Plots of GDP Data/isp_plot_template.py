"""
Project for Week 2 of "Python Data Visualization".
Read World Bank GDP data and create some basic XY plots.

Be sure to read the project description page for further information
about the expected behavior of the program.
"""

import csv
import pygal

def read_csv_fieldnames(filename, separator, quote):
    """
    Inputs:
      filename  - name of CSV file
      separator - character that separates fields
      quote     - character used to optionally quote fields
    Ouput:
      A list of strings corresponding to the field names in
      the given CSV file.
    """
    with open(filename, "r", newline='') as csv_file:
        csv_reader = csv.DictReader(csv_file,
                                    delimiter=separator,
                                    quotechar=quote)
        return csv_reader.fieldnames

def read_csv_as_list_dict(filename, separator, quote):
    """
    Inputs:
      filename  - name of CSV file
      separator - character that separates fields
      quote     - character used to optionally quote fields
    Output:
      Returns a list of dictionaries where each item in the list
      corresponds to a row in the CSV file.  The dictionaries in the
      list map the field names to the field values for that row.
    """
    header = read_csv_fieldnames(filename, separator, quote)
    table = []
    with open(filename, "r", newline='') as csv_file:
        csv_reader = csv.DictReader(csv_file,
                                    delimiter=separator,
                                    quotechar=quote)
        for row in csv_reader:
            my_dict = dict()
            for idx in range(len(header)):
                key = header[idx]
                my_dict[key] = row[key]
            table.append(my_dict)
    return table

def read_csv_as_nested_dict(filename, keyfield, separator, quote):
    """
    Inputs:
      filename  - Name of CSV file
      keyfield  - Field to use as key for rows
      separator - Character that separates fields
      quote     - Character used to optionally quote fields

    Output:
      Returns a dictionary of dictionaries where the outer dictionary
      maps the value in the key_field to the corresponding row in the
      CSV file.  The inner dictionaries map the field names to the
      field values for that row.
    """
    table_keys = []
    table = read_csv_as_list_dict(filename, separator, quote)
    with open(filename, "r", newline='') as csv_file:
        csv_reader = csv.DictReader(csv_file,
                                    delimiter=separator,
                                    quotechar=quote)
        for row in csv_reader:
            table_keys.append(row[keyfield])

    return dict(zip(table_keys, table))


def build_plot_values(gdpinfo, gdpdata):
    """
    Inputs:
      gdpinfo - GDP data information dictionary
      gdpdata - A single country's GDP stored in a dictionary whose
                keys are strings indicating a year and whose values
                are strings indicating the country's corresponding GDP
                for that year.

    Output: 
      Returns a list of tuples of the form (year, GDP) for the years
      between "min_year" and "max_year", inclusive, from gdpinfo that
      exist in gdpdata.  The year will be an integer and the GDP will
      be a float.
    """
    my_list = list()
    min_year = int(gdpinfo['min_year'])
    max_year = int(gdpinfo['max_year'])
    for (key, value) in gdpdata.items():
        if key.isdigit() and str(value) != '':
            year = int(key)
            if (year >= min_year) and (year <= max_year):
                my_list.append((year, float(value)))
    return sorted(my_list, key=lambda pair: pair[0])

def build_plot_dict(gdpinfo, country_list):
    """
    Inputs:
      gdpinfo      - GDP data information dictionary
      country_list - List of strings that are country names

    Output:
      Returns a dictionary whose keys are the country names in
      country_list and whose values are lists of XY plot values 
      computed from the CSV file described by gdpinfo.

      Countries from country_list that do not appear in the
      CSV file should still be in the output dictionary, but
      with an empty XY plot value list.
    """
    gdpfile = gdpinfo['gdpfile']
    country_name = gdpinfo['country_name']
    country_code = gdpinfo['country_code']
    separator = gdpinfo['separator']
    quote = gdpinfo['quote']
    read_countries = read_csv_as_nested_dict(gdpfile, country_name, separator, quote)
    my_dict = dict()
    for idx in range(len(country_list)):
        country = country_list[idx]
        if country in read_countries:
            read_countries[country].pop(country_name)
            read_countries[country].pop(country_code)
            my_dict[country] = build_plot_values(gdpinfo, read_countries[country])
        else:
            my_dict[country] = []
    return my_dict

def render_xy_plot(gdpinfo, country_list, plot_file):
    """
    Inputs:
      gdpinfo      - GDP data information dictionary
      country_list - List of strings that are country names
      plot_file    - String that is the output plot file name

    Output:
      Returns None.

    Action:
      Creates an SVG image of an XY plot for the GDP data
      specified by gdpinfo for the countries in country_list.
      The image will be stored in a file named by plot_file.
    """
    plot_dictionary = build_plot_dict(gdpinfo, country_list)
    gdp_chart = pygal.XY(x_title='Year', y_title='GDP in current US dollars')
    gdp_chart.title = 'Plot of GDP for select countries spanning 1960 to 2015'
    if len(plot_dictionary) == 0:
        gdp_chart.render_to_file(plot_file)
    else:
        for (key, value) in plot_dictionary.items():
            gdp_chart.add(key, value)
        gdp_chart.render_to_file(plot_file)

    return


def test_render_xy_plot():
    """
    Code to exercise render_xy_plot and generate plots from
    actual GDP data.
    """
    gdpinfo = {
        "gdpfile": "isp_gdp.csv",
        "separator": ",",
        "quote": '"',
        "min_year": 1960,
        "max_year": 2015,
        "country_name": "Country Name",
        "country_code": "Country Code"
    }

    render_xy_plot(gdpinfo, [], "isp_gdp_xy_none.svg")
    render_xy_plot(gdpinfo, ["China"], "isp_gdp_xy_china.svg")
    render_xy_plot(gdpinfo, ["United Kingdom", "United States"], "isp_gdp_xy_uk+usa.svg")


# Make sure the following call to test_render_xy_plot is commented out
# when submitting to OwlTest/CourseraTest.

# test_render_xy_plot()
