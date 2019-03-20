"""
Project for Week 3 of "Python Data Visualization".
Unify data via common country name.

Be sure to read the project description page for further information
about the expected behavior of the program.
"""

import csv
import math
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


def reconcile_countries_by_name(plot_countries, gdp_countries):
    """
    Inputs:
      plot_countries - Dictionary whose keys are plot library country codes
                       and values are the corresponding country name
      gdp_countries  - Dictionary whose keys are country names used in GDP data

    Output:
      A tuple containing a dictionary and a set.  The dictionary maps
      country codes from plot_countries to country names from
      gdp_countries The set contains the country codes from
      plot_countries that were not found in gdp_countries.
    """
    my_dict = dict()
    my_set = set()
    for (key, value) in plot_countries.items():
        if value in gdp_countries.keys():
            my_dict[key] = value
        else:
            my_set.add(key)
    return my_dict, my_set

def build_map_dict_by_name(gdpinfo, plot_countries, year):
    """
    Inputs:
      gdpinfo        - A GDP information dictionary
      plot_countries - Dictionary whose keys are plot library country codes
                       and values are the corresponding country name
      year           - String year to create GDP mapping for

    Output:
      A tuple containing a dictionary and two sets.  The dictionary
      maps country codes from plot_countries to the log (base 10) of
      the GDP value for that country in the specified year.  The first
      set contains the country codes from plot_countries that were not
      found in the GDP data file.  The second set contains the country
      codes from plot_countries that were found in the GDP data file, but
      have no GDP data for the specified year.
    """
    gdpfile = gdpinfo['gdpfile']
    country_name = gdpinfo['country_name']
    separator = gdpinfo['separator']
    quote = gdpinfo['quote']
    gdp_countries = read_csv_as_nested_dict(gdpfile, country_name, separator, quote)
    tuple_reconcile = reconcile_countries_by_name(plot_countries, gdp_countries)
    my_dict = dict()
    my_set = set()
    for (key, value) in tuple_reconcile[0].items():
        gdp_year = gdp_countries[value][year]
        if len(gdp_year) > 0:
            log10_gdp_year = math.log10(int(float(gdp_year)))
            my_dict[key] = log10_gdp_year
        else:
            my_set.add(key)
    return my_dict, tuple_reconcile[1], my_set


def render_world_map(gdpinfo, plot_countries, year, map_file):
    """
    Inputs:
      gdpinfo        - A GDP information dictionary
      plot_countries - Dictionary whose keys are plot library country codes
                       and values are the corresponding country name
      year           - String year to create GDP mapping for
      map_file       - Name of output file to create

    Output:
      Returns None.

    Action:
      Creates a world map plot of the GDP data for the given year and
      writes it to a file named by map_file.
    """
    map_data = build_map_dict_by_name(gdpinfo, plot_countries, year)
    world_map_chart = pygal.maps.world.World()
    world_map_chart.title = 'GDP by country for {} (log scale), unified by common country NAME'.format(year)
    world_map_chart.add('GDP for {}'.format(year), map_data[0])
    world_map_chart.add('Missing from World Bank Data', map_data[1])
    world_map_chart.add('No GDP data', map_data[2])
    world_map_chart.render_in_browser()
    return


def test_render_world_map():
    """
    Test the project code for several years.
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
    # render_to_file
    # Get pygal country code map
    pygal_countries = pygal.maps.world.COUNTRIES

    # 1960
    render_world_map(gdpinfo, pygal_countries, "1960", "isp_gdp_world_name_1960.svg")

    # 1980
    render_world_map(gdpinfo, pygal_countries, "1980", "isp_gdp_world_name_1980.svg")

    # 2000
    render_world_map(gdpinfo, pygal_countries, "2000", "isp_gdp_world_name_2000.svg")

    # 2010
    render_world_map(gdpinfo, pygal_countries, "2010", "isp_gdp_world_name_2010.svg")


# Make sure the following call to test_render_world_map is commented
# out when submitting to OwlTest/CourseraTest.

# test_render_world_map()
