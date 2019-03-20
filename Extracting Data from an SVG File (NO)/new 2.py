/**********************************************************************************
***********************************************************************************/
 read_csv_as_nested_dict('table1.csv', 'Field1', ',', '"') 
 expected {
	'5': {'Field3': '7', 'Field1': '5', 'Field4': '8', 'Field2': '6'}, 
	'9': {'Field3': '11', 'Field1': '9', 'Field4': '12', 'Field2': '10'}, 
	'1': {'Field3': '3', 'Field1': '1', 'Field4': '4', 'Field2': '2'}
} 
 but received {}
/**********************************************************************************
***********************************************************************************/
 build_plot_values(
{
	'country_name': 'Country Name', 'country_code': 'Code', 'quote': '', 
	'separator': '', 'gdpfile': '', 'max_year': 2000, 'min_year': 1980
}, {'1990': '20', '1995': '30', '1985': '10'}) 

expected [(1985, 10.0), (1990, 20.0), (1995, 30.0)] 
but received []
 
build_plot_dict(
{
	'country_name': 'Country Name', 'country_code': 'Code', 'quote': '"', 
	'separator': ',', 'gdpfile': 'gdptable1.csv', 'max_year': 2005, 'min_year': 2000
}, ['Country1']) 

expected {'Country1': [(2000, 1.0), (2001, 2.0), (2002, 3.0), (2003, 4.0), (2004, 5.0), (2005, 6.0)]} 
but received {}

build_plot_values(
{
	'country_name': 'Country Name', 'country_code': 'Code', 'quote': '', 
	'separator': '', 'gdpfile': '', 'max_year': 2000, 'min_year': 1980
}, {'1990': '20', '1995': '30', '1985': '10'}) 
expected [(1985, 10.0), (1990, 20.0), (1995, 30.0)] 
but received [('1990', '20'), ('1995', '30'), ('1985', '10')]

build_plot_values(
{
	'separator': '', 'max_year': 2015, 'gdpfile': '', 'country_code': 'Code', 
	'quote': '', 'min_year': 2001, 'country_name': 'Country Name'
}, {'2011': '10', '2002': '1', '2012': '11', '2004': '', '2005': '4', '2009': '8', '2008': '7', '2013': '', '2015': '14', '2010': '', '2006': '5', '2007': '', '2003': '2', '2014': '13', '2001': ''}) 

expected [(2002, 1.0), (2003, 2.0), (2005, 4.0), (2006, 5.0), (2008, 7.0), (2009, 8.0), (2011, 10.0), (2012, 11.0), (2014, 13.0), (2015, 14.0)] 
but received (Exception: ValueError) "could not convert string to float: " at line 96, in build_plot_values

build_plot_values(
{
	'country_name': 'Country Name', 'country_code': 'Code', 'quote': '', 'separator': '',
	'gdpfile': '', 'max_year': 2000, 'min_year': 1980
}, {'2000': '115', '1990': '110', '1980': '105', '2010': '120', '1970': '100'}) 
expected [(1980, 105.0), (1990, 110.0), (2000, 115.0)] 
but received [(1970, 100.0), (1980, 105.0), (1990, 110.0), (2000, 115.0), (2010, 120.0)]

build_plot_values(
{
	'country_name': 'Country Name', 'country_code': 'Code', 'quote': '', 
	'separator': '', 'gdpfile': '', 'max_year': 2000, 'min_year': 1980
}, {'Info': 'information', '19853': '36', '1965': 'abc', '2003': -7385.4}) 

expected [] 
but received (Exception: ValueError) "invalid literal for int() with base 10: 'Info'" at line 98, in build_plot_values

build_plot_values(
{
	'country_name': 'Country Name', 'country_code': 'Code', 'quote': '', 
	'separator': '', 'gdpfile': '', 'max_year': 2000, 'min_year': 1980
}, {'2000': '238489.38538', '1997': '753.3', '1998': '8283.2673', '1999': '138013.52'}) 

expected [(1997, 753.3), (1998, 8283.2673), (1999, 138013.52), (2000, 238489.38538)] 
but received []
/**********************************************************************************
***********************************************************************************/
 build_plot_dict(
 {
	'country_name': 'Country Name', 'country_code': 'Code', 'quote': '"', 
	'separator': ',', 'gdpfile': 'gdptable1.csv', 'max_year': 2005, 'min_year': 2000
}, ['Country1']) 
expected {'Country1': [(2000, 1.0), (2001, 2.0), (2002, 3.0), (2003, 4.0), (2004, 5.0), (2005, 6.0)]} 
but received {}

build_plot_dict(
{
	'country_name': 'Country Name', 'country_code': 'Code', 'quote': '"', 
	'separator': ',', 'gdpfile': 'gdptable1.csv', 'max_year': 2005, 'min_year': 2000
}, ['Country3']) 
expected {'Country3': []} 
but received {}
