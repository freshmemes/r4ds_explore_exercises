library(tidyverse)
library(hms)

# 10.5 Exercises -----------------------------------------------------------------------------------------------

# 1. How can you tell if an object is a tibble? (Hint: try printing mtcars, which is a regular data frame).

diamonds
mtcars

# A tibble would tell you it's a tibble and only prints the first 10 rows. A data frame prints all rows.

# 2. Compare and contrast the following operations on a data.frame and equivalent tibble. What is different? Why might 
# the default data frame behaviours cause you frustration?

df <- data.frame(abc = 1, xyz = "a")
df$x
df[, "xyz"]
df[, c("abc", "xyz")]

t <- as.tibble(df)
t$x
t$xyz
t[, "xyz"]
t[, c("abc", "xyz")]

# The data.frame allows us to use the shortcut $x to return the same thing that the tibble does when we have to
# explicitly specify the exact name $xyz. This makes data.frames kind of convenient but also kind of dangerous. What
# could be seen as really frustrating is that these operations on data.frames do not consistently return the same type.
# df[, "xyz"] returns a vector but df[. c("abc", "xyz")] returns a data.frame. The tibble feels a bit more comfortable
# here because they consistently returns tibbles in both cases.

# 3. If you have the name of a variable stored in an object, e.g. var <- "mpg", how can you extract the reference variable
# from a tibble?

temptibble <- tribble(
  ~mpg,
  1,
  2,
  3)
var <- "mpg"
temptibble[[var]] # like this I guess

# 4. Practice referring to non-syntactic names in the following data frame by:
# 1) Extracting the variable called 1.
# 2) Plotting a scatterplot of 1 vs 2.
# 3) Creating a new column called 3 which is 2 divided by 1.
# 4) Renaming the columns to one, two and three.

annoying <- tibble(
  `1` = 1:10,
  `2` = `1` * 2 + rnorm(length(`1`))
)

annoying[[1]] # 1)
ggplot(annoying, aes(`1`, `2`)) + geom_point() # 2)
(annoying2 <- mutate(annoying, `3` = `2` / `1`)) # 3)
transmute(annoying2, one = `1`, two = `2`, three = `3`) # 4)

#5. What does tibble::enframe() do? When might you use it?

?enframe

enframe(c("a", "b", "c"))
# Could be useful when we want to assign row numbers to vectors, or have ordinal rankings on some variable.

# 6. What option controls how many additional column names are printed at the footer of a tibble?

??tibble

# tibble.max_extra_cols

# 11.2.2 Exercises -----------------------------------------------------------------------------------------------

# 1. What function would you use to read a file where fields were separated with "|"?

# read_delim()

# 2. Apart from file, skip, and comment, what other arguments do read_csv() and read_tsv() have in common?

?read_csv
?read_tsv

# na, to deal with missing values
# col_names, to indicate whether there are column names
# escape_backslash, to indicate whether the file uses backslashes to escape special characters
# n_max, to indivate the max number of records to read
# quote, to specify the character used as a quote

# ... just to name a few

# 3. What are the most important arguments to read_fwf()?

?read_fwf

# file, to indicate which file to read
# col_positions, to select column positions
# col_types, to indicate the columns' types
# na, to deal with missing values
# skip, to indicate number of lines to skip
# comment, to identify string used for comments
# col_name, to specify column names if need be
# widths, to indicate the width of each field

# 4. Sometimes strings in a CSV file contain commas. To prevent them from causing problems they need to be surrounded by
# a quoting character, like " or '. By convention, read_csv() assumes that the quoting character will be ", and if you 
# want to change it you'll need to use read_delim() instead. What arguments do you need to specify to read the following
# text into a data frame? "x,y\n1,'a,b'"

?read_delim
read_delim("x,y\n1,'a,b'", delim = ",", quote = "'")

# 5. Identify what is wrong with each of the following inline CSV files. What happens when you run the code?

# Running each of the first three produces parsing failure warnings.

read_csv("a,b\n1,2,3\n4,5,6") # first row only has 2 columns when it needs 3
read_csv("a,b,c\n1,2\n1,2,3,4") # each row has a different number of columns
read_csv("a,b\n\"1") # first row has 2 cols, then comes a linebreak, somehow has another blackslash, then just one col
read_csv("a,b\n1,2\na,b") # honestly doesn't look like anything is wrong with this one
read_csv("a;b\n1;3") # interprets as a 1x1 table, should have used read_delim() to specify ";" as the delimiter

# 11.3.5 Exercises -----------------------------------------------------------------------------------------------

# 1. What are the most important arguments to locale()?

?locale
# date_names, date_format, time_format, encoding, decimal_mark, tz

# 2. What happens if you try and set decimal_mark and grouping_mark to the same character? What happens to the default 
# value of grouping_mark when you set decimal_mark to ","? What happens to the default value of decimal_mark when you set 
# the grouping_mark to "."?

parse_number("1,234,567.89", locale = locale(decimal_mark = ",", grouping_mark = ","))
# produces an error that tells us the marks must be different

parse_number("1234567", locale = locale(decimal_mark = ","))
# defaults to no grouping apparently

parse_number("1234567.89", locale = locale(grouping_mark = "."))
# defaults to no decimal mark... sketchy

# 3. I didn't discuss the date_format and time_format options to locale(). What do they do? Construct an example that 
# shows when they might be useful.

# They format dates and times, I guess. Useful when Euro-hipsters write things differently.

parse_datetime("2017-10-01", locale = locale(date_format = "%Y-%d-%m"))
parse_datetime("2017-10-01", locale = locale(date_format = "%Y-%m-%d"))

# 4. If you live outside the US, create a new locale object that encapsulates the settings for the types of file you read
# most commonly.

# I don't live outside the US, but I guess I'll do it anyway:
eu <- locale(date_names = "fr", decimal_mark = ",", grouping_mark = ".", tz = "Europe/Paris")
parse_datetime("2017-10-01 12:00", locale = eu)

# 5. What's the difference between read_csv() and read_csv2()?

?read_csv
?read_csv2
