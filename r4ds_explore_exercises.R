library(tidyverse)
library(nycflights13)
library(ggstance)
library(lvplot)
library(ggbeeswarm)
library(hexbin)

# 3.2.4 Exercises -----------------------------------------------------------------------------------------------


# 1. Run ggplot(data = mpg). What do you see?

ggplot(data = mpg) 

# Nothing, it just loaded the data source but we did not specify any geometric/aesthetic mappings.

# 2. How many rows are in mpg? How many columns?

mpg

# 234 rows x 11 columns

# 3. What does the drv variable describe? Read the help for ?mpg to find out.

?mpg

# drv specifies the car's drivetrain type: front, rear, or all wheel drive

# 4. Make a scatterplot of hwy vs cyl.

ggplot(data = mpg) + geom_point(mapping = aes(x = cyl, y = hwy))

# 5. What happens if you make a scatterplot of class vs drv? Why is the plot not useful?

ggplot(data = mpg) + geom_point(mapping = aes(x = drv, y = class))

# So it shows you the combination of vehicle classes and drivetrains in the dataset, but it's not particularly useful
# because it doesn't tell you just how many data points there are in each combo. The limitation of the scatterplot is
# that it only tells us the binary of whether that combo exists in the data set but not the frequency of occurrence.

# 3.3.1 Exercises -----------------------------------------------------------------------------------------------

# 1. What's gone wrong with this code? Why are the points not blue?
# ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, color = "blue"))

# color = "blue" should be set outside of the aes() function, as in the following:
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy), color = "blue")

# 2. Which variables in mpg are categorical? Which variables are continuous? (Hint: type ?mpg to read the documentation 
# for the dataset). How can you see this information when you run mpg?

?mpg

# continuous: displ, cty, hwy
# categorical: manufacturer, model, year, cyl, trans, drv, fl, class
# Running mpg shows a view of the top 10 rows of the table. Under each column name it lists the data type.

# 3. Map a continuous variable to color, size, and shape. How do these aesthetics behave differently for 
# categorical vs. continuous variables?

ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, color = cty))
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, color = manufacturer))
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, shape = cty))
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, shape = manufacturer))
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, size = cty))
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, size = manufacturer))

# For categorical variables, there is a set of discrete colors. For continuous variables, there is a color gradient.
# For categorical variables, shape works as expected but the set size is limited. ggplot() does not allow continuous
# variables to be mapped to the shape aesthetic.
# ggplot() warns that mapping a categorical variable to size is a derpy thing to do. For continuous variables, it
# behaves as expected, with a continuous scale of different sizes for each datum.

# 4. What happens if you map the same variable to multiple aesthetics?

ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, color = cty, size = cty))
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, color = manufacturer, shape = manufacturer))

# Seems to work perfectly fine to me, as long as we bear in mind the limitations from question #3 (namely, not to map
# continuous variables to shape and remember there are only 6 discrete shapes by default). The variable in question
# now just has multiple aesthetic properties.

# 5. What does the stroke aesthetic do? What shapes does it work with? (Hint: use ?geom_point)

?geom_point

# According to the documentation, stroke modifies the width of the border. This is apparent in comparing the below:
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, color = manufacturer, stroke = 3))
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, color = manufacturer, stroke = 10))

# 6. What happens if you map an aesthetic to something other than a variable name, like aes(colour = displ < 5)?

ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, color = displ < 5))

# This works fine, since displ < 5 itself acts as a boolean variable. In this case, the data are split into 2 colors.

# 3.5.1 Exercises -----------------------------------------------------------------------------------------------

# 1. What happens if you facet on a continuous variable?

ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy)) + facet_wrap(~ cty)

# It does it, but if there are many different values of that variable, the sheer number of panels could get obnoxious.

# 2. What do the empty cells in plot with facet_grid(drv ~ cyl) mean? How do they relate to this plot?
# ggplot(data = mpg) + geom_point(mapping = aes(x = drv, y = cyl))

# The empty cells in the result of
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy)) + facet_grid(drv ~ cyl)
# mean that those combos do not exist, i.e. in this case there are no 4 or 5 cylinder RWD vehicles in the data set.
# Nor are there any 5 cylinder AWD vehicles in the data set.

# The plot mentioned in the question confirms this because it does not contain any data points for those same
# combinations that resulted in the empty panels in the faceted view.

# 3. What plots does the following code make? What does . do?

ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy)) + facet_grid(drv ~ .)
# is a view of highway mileage vs. displacement, segmented by the type of drivetrain.

ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy)) + facet_grid(. ~ cyl)
# is a view of highway mileage vs. displacement, segmented by the number of cylinders.

# In either case, the . is a placeholder in the formula that means we don't want to segment the panel view by a
# second dimension.

# 4. Take the first faceted plot in this section: ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy)) + 
# facet_wrap(~ class, nrow = 2) 
# What are the advantages to using faceting instead of the colour aesthetic? What are the disadvantages? 
# How might the balance change if you had a larger dataset?

# Compare to the view generated by mapping color to class
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, color = class))
# the paneled view makes it easier to see the relationship between the x/y variables within each class, relative to
# the other data in the same class. However, the advantage of segmenting by color is that it makes it easier to see
# any datum relative to _all_ of the data, not just those in the same category. In a larger dataset, it may become
# more difficult to distinguish the colors, so the panel view could be more advantageous in many cases (in situations
# where a large number of categories makes forces the aesthetic to adopt colors that look similar to each other).

# 5. Read ?facet_wrap. What does nrow do? What does ncol do? What other options control the layout of the individual 
# panels? Why doesn't facet_grid() have nrow and ncol argument?

?facet_wrap
?facet_grid

# nrow and ncol control the number of rows and columns that the faceted display uses. Other parameters of facet_wrap()
# include as.table which controls where the highest values are laid out, dir which controls the vertical/horizontal
# direction of the panels, and shrink which can shrink the scale of the plots.

# 6. When using facet-grid() you should usually put the variable with more unique levels in the columns. Why?

# It's easier for graphs to get vertically smushed than horizontally smushed, due to most monitors' aspect ratios.

# 3.6.1 Exercises -----------------------------------------------------------------------------------------------

# 1. What geom would you use to draw a line chart? A box plot? A histogram? An area chart?

# geom_line(), geom_boxplot(), geom_histogram(), geom_area()

# 2. Run this code in your head and predict what the output will look like. 
# Then, run the code in R and check your predictions.

# Prediction: x axis shows displacement, y axis shows hwy mpg, scatterplot of all data points, with each datums' color
# determined by its drivetrain type. Layered on top of that are three smooth lines, one of a different color for each
# type of drivetrain (AWD, FWD, RWD). There is no shaded standard error zone for any of the lines due to the se arg.

ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
  geom_point() + 
  geom_smooth(se = FALSE)

# 3. What does show.legend = FALSE do? What happens if you remove it? Why do you think I used it earlier in the 
# chapter?

# show.legend = FALSE hides the legend for the plot; without setting this param to FALSE, legends are displayed by
# default. So removing it will show the legend. I think you used it earlier to illustrate how helpful it is to
# actually have a legend, without which it becomes harder to tell which colors stand for what.

# 4. What does the se argument to geom_smooth() do?

?geom_smooth
# it displays a shaded confidence interval around the smooth line; se is set to TRUE by default.

# 5. Will these to graphs look different? Why/why not?
# ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
#   geom_point() +
#   geom_smooth()
# ggplot() +
#   geom_point(data = mpg, mapping = aes(x = displ, y = hwy)) +
#   geom_smooth(data = mpg, mapping = aes(x = displ, y = hwy))

# No, they will not look different because they are just two different syntaxes for the same thing. In either case,
# ggplot is setting the same data and mapping the same aesthetics to both geom_point and geom_smooth. Just that in the
# first one, it is setting everything globally initially, which is implicitly inherited by the following layers. While
# in the second one, it is explicitly setting everything in each of the two individual layers after ggplot().

# 6. Recreate the R code necessary to generate the following graphs.

# From left to right starting from top row:
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + geom_point() + geom_smooth(se = FALSE, show.legend = FALSE)
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + geom_point() + 
  geom_smooth(se = FALSE, show.legend = FALSE, mapping = aes(class = drv))
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + geom_point() + 
  geom_smooth(se = FALSE, mapping = aes(class = drv))
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + geom_point(mapping = aes(class = drv, color = drv)) + 
  geom_smooth(se = FALSE)
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + geom_point(mapping = aes(class = drv, color = drv)) + 
  geom_smooth(se = FALSE, mapping = aes(linetype = drv))
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + geom_point(color = "white", stroke = 3) +
  geom_point(mapping = aes(color = drv))

# 3.7.1 Exercises -----------------------------------------------------------------------------------------------

# 1. What is the default geom associated with stat_summary()? How could you rewrite the previous plot to use that 
# geom function instead of the stat function?

?stat_summary
# geom_pointrange is its default. The example plot could be rewritten as
ggplot(data = diamonds) + 
  geom_pointrange(mapping = aes(x = cut, y= depth), fun.ymin = min, fun.ymax = max, fun.y = median, stat = "summary")

# 2. What does geom_col() do? How is it different to geom_bar()?

?geom_col
ggplot(data = diamonds) + geom_bar(mapping = aes(x = cut))
ggplot(data = diamonds) + geom_col(mapping = aes(x = cut, y = depth))

# Looks like with geom_col, it sums the y values for each bin, instead of counting the number of instances of each bin.

# 3. Most geoms and stats come in pairs that are almost always used in concert. Read through the documentation and make
# a list of all the pairs. What do they have in common?

# stat_bin() :: geom_bar()
# stat_bin2d() :: geom_tile()
# stat_bin_2d() :: geom_tile()
# stat_bin_hex() :: geom_hex()
# stat_binhex() :: geom_hex()
# stat_boxplot() :: geom_boxplot()
# stat_contour() :: geom_contour()
# stat_count() :: geom_bar()
# stat_density() :: geom_area()
# stat_density2d() :: geom_density2d()
# stat_density_2d() :: geom_density_2d()
# stat_ecdf() :: geom_path()
# stat_ellipse() :: geom_path()
# stat_function() :: geom_point()
# stat_identity() :: geom_point()
# stat_qq() :: geom_point()
# stat_quantile() :: geom_quantile()
# stat_smooth() :: geom_smooth()
# stat_sum() :: geom_point()
# stat_summary() :: geom_pointrange()
# stat_summary2d() :: geom_pointrage()
# stat_summary_2d() :: geom_tile()
# stat_summary_bin() :: geom_pointrange()
# stat_summary_hex() :: geom_hex()
# stat_unique() :: geom_point()
# stat_ydensity() :: geom_violin()

# What they have in common is that the default geom for each stat is an intuitive visualization of that stat.

# 4. What variables does stat_smooth() compute? What parameters control its behaviour?

# It computes predicted values and a confidence interval/standard error. Parameters that control its behavior include
# the span of the smoothness, formula used in the smoothing function, confidence level, etc.

# 5. In our proportion bar chart, we need to set group = 1. Why? In other words what is the problem with these two 
# graphs?
# ggplot(data = diamonds) + geom_bar(mapping = aes(x = cut, y = ..prop..))
# ggplot(data = diamonds) + geom_bar(mapping = aes(x = cut, fill = color, y = ..prop..))

# We need to pass group = 1 in order to let it know that we want the proportion of each bin to _everything_.
# In the two problematic graphs, because no group = 1 is specified, it is still grouping by the x variable by default.
# In other words, the proportion of "fair" count to "fair" count, the proportion of "good" count to "good" count, etc.
# This means every bin will be 1 because it is just calculating the prop of each bin's count to itself.

# 3.8.1 Exercises -----------------------------------------------------------------------------------------------

# 1. What is the problem with this plot? How could you improve it?
# ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + geom_point()

# Overplotting; introduce some jitter.
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + geom_jitter()

# 2. What parameters to geom_jitter() control the amount of jittering?

?geom_jitter
# width and height

# 3. Compare and contrast geom_jitter() with geom_count().

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + geom_count()
# geom_jitter() deals with the problem of overplotting by shaking apart the points so you can see them as distinct, 
# whereas geom_count() uses area size to show you how many points occupy each local cluster.

# 4. What's the default position adjustment for geom_boxplot()? Create a visualisation of the mpg dataset that 
# demonstrates it.

?geom_boxplot
# "dodge"
ggplot(data = mpg, mapping = aes(x = drv, y = hwy, fill = class)) + geom_boxplot()

# 3.9.1 Exercises -----------------------------------------------------------------------------------------------

# 1. Turn a stacked bar chart into a pie chart using coord_polar().

# Well, r4ds hasn't really explained factors yet but according to
?coord_polar
# this should work
ggplot(data = diamonds, mapping = aes(x = factor(1), fill = cut)) + geom_bar(width = 1) + coord_polar(theta = "y")

# 2. What does labs() do? Read the documentation.

?labs
# Looks like it lets you add labels to your graphs.

# 3. What's the difference between coord_quickmap() and coord_map()?

?coord_quickmap
?coord_map
# coord_map() is more precise, while coord_quickmap() uses straight lines to compute faster.

# 4. What does the plot below tell you about the relationship between city and highway mpg? 
# Why is coord_fixed() important? What does geom_abline() do?
# ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + geom_point() + geom_abline() + coord_fixed()

# The plot suggests that vehicles with high city mpg also have high highway mpg, and vice versa. I.e. fuel efficient
# cars tend to be fuel efficient in general, and fuel inefficient cars tend to be fuel inefficient in general.

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + geom_point() + geom_abline() + coord_fixed()
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + geom_point() + geom_abline()
?coord_fixed

# coord_fixed() compensates for your monitor's aspect ratio so that 1 unit of x and 1 unit of y take up the same
# number of pixels on the screen. Hooray.

?geom_abline
# y = ax + b; basically shows the slope based on the relationship between y/x 

# 4.4 Practice -----------------------------------------------------------------------------------------------

# 1. Why does this code not work?
# my_variable <- 10
# my_variable
# > Error in eval(expr, envir, enclos): object 'my_variable' not found

# There is a typo in the second line where the "i" in "my_variable" is some other weird character instead.

# 2. Tweak each of the following R commands so that they run correctly:

# library(tidyverse)
# I'm confused; the above command already looks correct.

# ggplot(dota = mpg) + geom_point(mapping = aes(x = displ, y = hwy))
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy))

# fliter(mpg, cyl = 8)
filter(mpg, cyl == 8)

# filter(diamond, carat > 3)
filter(diamonds, carat > 3)

# 3. Press Alt + Shift + K. What happens? How can you get to the same place using the menus?

# A dank keyboard shortcut reference comes up. This is also accessible under the Help Menu, "Keyboard Shortcuts Help"
# which can also be accessed with Alt, H, K, which is nice because Alt-Shift changes my keyboard language/layout.

# 5.2.4 Exercises -----------------------------------------------------------------------------------------------

# 1. Find all flights that

#   1. Had an arrival delay of two or more hours
(filter(flights, arr_delay >= 120))
#   2. Flew to Houston (IAH or HOU)
(filter(flights, dest %in% c("IAH", "HOU")))
#   3. Were operated by United, American, or Delta
(filter(flights, carrier %in% c("UA", "AA", "DL")))
#   4. Departed in summer (July, August, and September)
(filter(flights, month %in% c(7, 8, 9)))
#   5. Arrived more than two hours late, but didn't leave late
(filter(flights, arr_delay > 120 & (is.na(dep_delay) | dep_delay <= 0)))
#   6. Were delayed by at least an hour, but made up over 30 minutes in flight
(filter(flights, dep_delay >= 60 & arr_delay < 30))
#   7. Departed between midnight and 6am (inclusive)
(filter(flights, dep_time >= 0 & dep_time <= 600))

# 2. Another useful dplyr filtering helper is between(). What does it do? Can you use it to simplify the code needed 
# to answer the previous challenges?

# between() is what it sounds like, basically shorthand for an inclusive range, i.e. >= one thing and <= another
# Could have slightly simplified questions 4 and 7 above as follows:
(filter(flights, between(month, 7, 9)))
(filter(flights, between(dep_time, 0 , 600)))

# 3. How many flights have a missing dep_time? What other variables are missing? What might these rows represent?

mdt <- (filter(flights, is.na(dep_time)))
View(mdt)
# 8225 flights with missing dep_time seem to also be missing dep_delay, arr_time, arr_delay, and air_time
# Hypothesis: these rows represent flights that were rescheduled, cancelled, or never took off for whatever reason.

# 4. Why is NA ^ 0 not missing? Why is NA | TRUE not missing? Why is FALSE & NA not missing? Can you figure out the 
# general rule? (NA * 0 is a tricky counterexample!)

NA ^ 0 
# any number to the zeroth power is 1; however, I have some qualms about this - what if the data in question was not
# a numeric?
NA | TRUE
# anything OR true will produce true
FALSE & NA
# anything AND false will produce false, following basic boolean logic just like the above
NA * 0
# again kind of weird; I would almost argue that NA*0=0 would be more justified than NA^0=1 but whatevs broh

# General rule: anything that will produce the same result regardless of what it is being applied to, will supersede
# NA as expected... except for multiplication by 0, apparently.

# 5.3.1 Exercises -----------------------------------------------------------------------------------------------

# 1. How could you use arrange() to sort all missing values to the start? (Hint: use is.na()).

arrange(flights, desc(is.na(dep_time + arr_time)))

# 2. Sort flights to find the most delayed flights. Find the flights that left earliest.

arrange(flights, desc(dep_delay))
arrange(flights, dep_time)

# 3. Sort flights to find the fastest flights

arrange(flights, air_time)

# 4. Which flights travelled the longest? Which travelled the shortest?

arrange(flights, desc(distance))
arrange(flights, distance)

# 5.4.1 Exercises -----------------------------------------------------------------------------------------------

# 1. Brainstorm as many ways as possible to select dep_time, dep_delay, arr_time, and arr_delay from flights.

select(flights, dep_time, dep_delay, arr_time, arr_delay)
select(flights, starts_with("dep"), starts_with("arr"))
select(flights, ends_with("time"), ends_with("delay"))

# 2. What happens if you include the name of a variable multiple times in a select() call?

select(flights, dep_time, dep_time, dep_time, arr_time, arr_time, arr_time, arr_time, dep_time, dep_time)
# Looks like R will only return each distinct column once.

# 3.What does the one_of() function do? Why might it be helpful in conjunction with this vector?
vars <- c("year", "month", "day", "dep_delay", "arr_delay")

?one_of
#Seems to act like an in statement for matches() so you don't have to type out matches(a) | matches(b) | ... etc.

select(flights, one_of(vars))

# 4. Does the result of running the following code surprise you? How do the select helpers deal with case by default? 
# How can you change that default?

select(flights, contains("TIME"))

# Doesn't really surprise me, I guess it's interesting that contains() is case-insensitive by default. We could
# change this default by passing FALSE as the ignore.case argument.

select(flights, contains(ignore.case = FALSE, "TIME"))

# 5.5.2 Exercises -----------------------------------------------------------------------------------------------

# 1. Currently dep_time and sched_dep_time are convenient to look at, but hard to compute with because they're not 
# really continuous numbers. Convert them to a more convenient representation of number of minutes since midnight.

transmute(flights, dep_time, sched_dep_time, dep_min = (dep_time %/% 100) * 60 + dep_time %% 100, sched_dep_min = 
  (sched_dep_time %/% 100) * 60 + sched_dep_time %% 100)

# 2. Compare air_time with arr_time - dep_time. What do you expect to see? What do you see? What do you need to do to 
# fix it?

transmute(flights, air_time, arr_time - dep_time)

# As expected, arr_time - dep_time is off because it is subtracting the raw time stamps which are not based on
# 60-minute hours. To fix this, we can do the following
transmute(flights, dep_time, arr_time, air_time, diff = ((arr_time %/% 100) * 60 + arr_time %% 100) - 
  ((dep_time %/% 100) * 60 + dep_time %% 100))
# But even then, air_time does not match up with the # of minutes between dep_time and arr_time. In fact, we can see
# see that this was the case in the raw data set. Presumably runway time would not count toward "air" time.
# Furthermore, there is the issue of possible negative differences of arr_time - dep_time if a flight left at night
# and arrived shortly after midnight on the following day. Finally, some of the data just seems wrong. E.g. flight has
# a dep_time of 558 and arr_time of 753 and its air_time is logged as 138?? Not sure how to fix this to be honest.

# 3. Compare dep_time, sched_dep_time, and dep_delay. How would you expect those three numbers to be related?

# I would expect dep_delay to be the minutes difference from dep_time - sched_dep_time.
(select(flights, contains("dep")))
# This appears to be the case.

# 4. Find the 10 most delayed flights using a ranking function. How do you want to handle ties? Carefully read the 
# documentation for min_rank().

?min_rank

select(arrange(mutate(flights, dep_delay_rank = min_rank(desc(dep_delay))), dep_delay_rank), dep_delay_rank, 
  everything())

# I mean, there are no ties in the top 10 so... I guess if it were a tiebreak I would say that the flight with the
# lower air_time counts as "more delayed" since the same delay would be a larger % of its total travel time.

# 5. What does 1:3 + 1:10 return? Why?

1:3 + 1:10
# Warning message: longer object length is not a multiple of shorter object length.
# Guess this is R saying that we can't operate on two vectors of different lengths.

# 6. What trigonometric functions does R provide?

# Uh... I'm gonna guess/hope all of them?
?Trig
# Seems to include at least cos, sin, tan, acos, asin, atan, atan2, cospi, sinpi, and tanpi.

# 5.6.7 Exercises -----------------------------------------------------------------------------------------------

# 1. Brainstorm at least 5 different ways to assess the typical delay characteristics of a group of flights. 

# Some different ways: morning delay proportion vs. afternoon delay proportion, average delay by day, average delay
# by airline, airlines listed in order of fewest 60+ minute delays relative to number of flights, whether there are
# more departure or arrival delays on each day
not_cancelled <- filter(flights, !is.na(dep_delay), !is.na(arr_delay))
not_cancelled %>% 
  summarize(morning_delays = sum(arr_delay > 0 & sched_arr_time < 1200), afternoon_delays = 
    sum(arr_delay > 0 & sched_arr_time >= 1200))
not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarize(avg_delay = mean(arr_delay))
not_cancelled %>% 
  group_by(carrier) %>% 
  summarize(avg_delay = mean(arr_delay))
not_cancelled %>% 
  group_by(carrier) %>% 
  summarize(long_delays = sum(arr_delay > 60)) %>% arrange(long_delays)
not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarize(more_dep_delays = sum(dep_delay > 0) > sum(arr_delay > 0),
    more_arr_delays = sum(arr_delay > 0) > sum(dep_delay > 0))

# Consider the following scenarios:
# A flight is 15 minutes early 50% of the time, and 15 minutes late 50% of the time.
# A flight is always 10 minutes late.
# A flight is 30 minutes early 50% of the time, and 30 minutes late 50% of the time.
# 99% of the time a flight is on time. 1% of the time it's 2 hours late.
# Which is more important: arrival delay or departure delay?

# IMO, arrival delay is more important since that's how far you were actually off from when you expected to get to
# your destination. Even if departure delay is terrible, as long as you were able to make up time in-flight and end
# up arriving on time, all that really happened is that you gave tardy passengers more time to make the flight; no
# real harm done if you still arrived on time.

# 2. Come up with another approach that will give you the same output as not_cancelled %>% count(dest) and 
# not_cancelled %>% count(tailnum, wt = distance) (without using count()).

not_cancelled %>% group_by(dest) %>% summarize(n())
not_cancelled %>% group_by(tailnum) %>% summarize(sum(distance))

# 3. Our definition of cancelled flights ( is.na(dep_delay) | is.na(arr_delay) ) is slightly suboptimal. Why? Which is 
# the most important column?

View(filter(flights, is.na(dep_delay) | is.na(arr_delay)))

# It is potentially including some non-cancelled flights; just because one of the delay variables is NA does not
# necessarily mean that the flight was cancelled. E.g. arr_delay may be NA because it landed on time, or dep_delay
# may be NA because it departed on time. However, I am going to make the assumption that in the latter case,
# dep_delay would just log a value of 0. So, with that assumption, we should filter to cancelled flights using
# (is.na(dep_delay)). But outside of those two variables, my preference would be to use (is.na(dep_time)).
# Side note: weird that there are so many NA values for air_time where dep_time and arr_time are both populated.

# 4. Look at the number of cancelled flights per day. Is there a pattern? Is the proportion of cancelled flights 
# related to the average delay?

bruh <- group_by(flights, year, month, day) %>% 
  summarize(pct_cncld = sum(is.na(dep_time)) / n(), avg_delay = mean(dep_delay, na.rm = TRUE))

ggplot(data = bruh, mapping = aes(x = avg_delay, y = pct_cncld)) + geom_point(alpha = 1/8, color = "red") + 
  geom_smooth(se = FALSE)

# There seems to be a positive correlation between average delay time and % of flights cancelled. This sort of makes
# intuitive sense when you think of severe weather scenarios causing many flights to be delayed before more flights
# are eventually outright cancelled.

# 5. Which carrier has the worst delays? Challenge: can you disentangle the effects of bad airports vs. bad carriers?
# Why/why not? (Hint: think about flights %>% group_by(carrier, dest) %>% summarise(n()))

not_cancelled %>% group_by(carrier) %>% summarize(avg_delay = mean(arr_delay)) %>% arrange(desc(avg_delay))

# F9 a.k.a. Frontier airlines, has the longest average delays.

# To the question of the effects of bad airports vs. bad carriers, without further information it feels like a chicken
# and egg type of conundrum. Even if we find a pattern of carriers with long delays usign airports with long delays
# (and vice versa), how do we know whose fault it is?

not_cancelled %>% group_by(dest) %>% summarize(avg_delay = mean(arr_delay)) %>% arrange(desc(avg_delay))
not_cancelled %>% group_by(carrier, dest) %>% summarise(n())

# I suppose with these three tibbles, we can calculate expected value of arr_delay for each carrier based on its
# airport usage mix. And likewise we can calculate expected value of arr_delay for each airport based on its carrier
# mix. Or, perhaps we can use filters to limit, for instance, the data set to just airports with similar average
# delays. Even then, the chicken and egg problem still persists since there is not a large enough set of common
# airports used by the different airlines to produce a robust comparison.

# 6. What does the sort argument to count() do. When might you use it?

?count
# According to the documentation, the sort arg if TRUE will order the count() results in descending order.
# This could come in handy as a shortcut to see which airports have the most flights, for example.
flights %>% count(sort = TRUE, dest)

# 5.7.1 Exercises -----------------------------------------------------------------------------------------------

# 1. Refer back to the lists of useful mutate and filtering functions. Describe how each operation changes when you 
# combine it with grouping.

# Grouping has a fairly intuitive effect on filters. It just applies the filter on the level you're grouping by
# instead of to the most granular level of the whole data set. Same thing for mutate. Calculations roll up into the
# appropriate aggregations specified by the group_by(), the same way data would roll up in a pivot table.

# 2. Which plane (tailnum) has the worst on-time record?

not_cancelled %>% group_by(tailnum) %>% 
  summarize(count = n(), ontime_perc = sum(arr_delay = 0) / n()) %>% 
  filter(count > 50)

# Well, looks like no one is technically ever "on time" so we need to revise the definition, maybe to anything less
# than a 15 minute arrival delay.

not_cancelled %>% group_by(tailnum) %>% 
  summarize(count = n(), ontime_perc = sum(arr_delay < 15) / n()) %>% 
  filter(count > 50) %>% 
  arrange(ontime_perc)

# Out of planes that took more than 50 flights in 2013, tailnum N13970 had the worst "on time" percentage.

#3. What time of day should you fly if you want to avoid delays as much as possible?

not_cancelled %>% group_by(hour = sched_dep_time %/% 100) %>% summarize(avg_delay = mean(arr_delay))

# Apparently you should leave during the 7 am hour.

# 4. For each destination, compute the total minutes of delay. For each, flight, compute the proportion of the total 
# delay for its destination.

not_cancelled %>% filter(arr_delay > 0) %>% group_by(dest) %>% summarize(sum(arr_delay))

not_cancelled %>% filter(arr_delay > 0) %>% group_by(dest) %>% mutate(prop_delay = arr_delay / sum(arr_delay)) %>% 
  select(prop_delay, everything())

# 5. Delays are typically temporally correlated: even once the problem that caused the initial delay has been resolved,
# later flights are delayed to allow earlier flights to leave. Using lag() explore how the delay of a flight is related
# to the delay of the immediately preceding flight.

temp <- not_cancelled %>% 
  filter(dep_delay > 0, !is.na(dep_time)) %>% 
  arrange(year, month, day, dep_time)

transmute(temp, dep_time, dep_delay, prev_dep_delay = lag(dep_delay))

ggplot(data = transmute(temp, dep_time, dep_delay, prev_dep_delay = lag(dep_delay))) + geom_jitter(mapping =
  aes(x = prev_dep_delay, y = dep_delay), alpha = 1/50)
# Seems legit.

# 6. Look at each destination. Can you find flights that are suspiciously fast? (i.e. flights that represent a 
# potential data entry error). Compute the air time a flight relative to the shortest flight to that destination. 
# Which flights were most delayed in the air?

flights %>% group_by(dest) %>% 
  filter((sched_arr_time %/% 100 * 60 + sched_arr_time %% 100) - 
    (sched_dep_time %/% 100 * 60 + sched_dep_time %% 100) - air_time > 60) %>% 
  mutate(ahead = (sched_arr_time %/% 100 * 60 + sched_arr_time %% 100) - (sched_dep_time %/% 100 * 60 + 
    sched_dep_time %% 100) - air_time) %>% 
  select(dest, tailnum, sched_dep_time:sched_arr_time, dep_time, arr_time, air_time, ahead)

not_cancelled %>% group_by(dest) %>% 
  mutate(delta_vs_shortest = air_time - min(air_time)) %>% 
  select(delta_vs_shortest, everything())

not_cancelled %>% 
  mutate(delta_vs_expected_air_time = air_time - ((sched_arr_time %/% 100 * 60 + sched_arr_time %% 100) - 
    (sched_dep_time %/% 100 * 60 + sched_dep_time %% 100)), delta_due_to_air = delta_vs_expected_air_time - 
  dep_delay) %>%  
  select(air_time, delta_due_to_air, everything()) %>% 
  arrange(desc(delta_due_to_air))

# 7. Find all destinations that are flown by at least two carriers. Use that information to rank the carriers.

flights %>% group_by(dest) %>% filter(n_distinct(carrier) >= 2) %>% summarize(carriers = n_distinct(carrier))

flights %>% group_by(dest) %>% filter(n_distinct(carrier) >= 2) %>% group_by(carrier) %>% 
  summarize(dests = n_distinct(dest)) %>% 
  arrange(desc(dests))

# 8. For each plane, count the number of flights before the first delay of greater than 1 hour.

tempplanes <- not_cancelled %>% 
  filter(!is.na(dep_time)) %>% 
  arrange(tailnum, year, month, day, dep_time) %>%
  group_by(tailnum) %>% 
  mutate(row = row_number()) %>% 
  select(row, everything())

tempplanes %>% filter(dep_delay > 60) %>% 
  mutate(row2 = row_number()) %>% 
  select(row2, everything()) %>% 
  filter(row2 == 1) %>% 
  transmute(flight, die_antwoord = row - 1)

# 6.3 Practice -----------------------------------------------------------------------------------------------

# 1. Go to the RStudio Tips twitter account, https://twitter.com/rstudiotips and find one tip that looks
# interesting. Practice using it!

# Sweet, I just found out that Rstudio has different themes. Now my editor and console can look dank.

# 2. What other common mistakes will RStudio diagnostics report? Read 
# https://support.rstudio.com/hc/en-us/articles/205753617-Code-Diagnostics to find out.

# Apparently it will also diagnose if you use mismatched arguments, try to reference variables outside
# of scope, warn about unused variables, bad formatting/styling, and even has packages for diagnostics
# for other languages like C++ and Python.

# 7.3.4 Exercises -----------------------------------------------------------------------------------------------

# 1. Explore the distribution of each of the x, y, and z variables in diamonds. What do you learn? Think about a 
# diamond and how you might decide which dimension is the length, width, and depth.

ggplot(data = diamonds, mapping = aes(x = x)) + geom_histogram(binwidth = 0.01)
ggplot(data = diamonds, mapping = aes(x = y)) + geom_histogram(binwidth = 0.01) + coord_cartesian(xlim = c(0, 10))
ggplot(data = diamonds, mapping = aes(x = z)) + geom_histogram(binwidth = 0.01) + coord_cartesian(xlim = c(0, 10))

?diamonds
# x = length, y = width, z = depth
# Assuming a diamond stands up straight, with its tip touching the table, and its flat top parallel to the table
# x = length = longest dimension, straight horizontal shot from left to right
# y = width  = second longest dimension, from front to back; together with length creates a plane parallel to the
# table surface
# z = depth = distance from the diamond's tip to its flat top, essentially its "height"

# 2. Explore the distribution of price. Do you discover anything unusual or surprising? (Hint: Carefully think about
# the binwidth and make sure you try a wide range of values.)

ggplot(data = diamonds, mapping = aes(x = price)) + geom_histogram(binwidth = 20000)
ggplot(data = diamonds, mapping = aes(x = price)) + geom_histogram(binwidth = 10000)
ggplot(data = diamonds, mapping = aes(x = price)) + geom_histogram(binwidth = 5000)
ggplot(data = diamonds, mapping = aes(x = price)) + geom_histogram(binwidth = 1000)
ggplot(data = diamonds, mapping = aes(x = price)) + geom_histogram(binwidth = 100)
ggplot(data = diamonds, mapping = aes(x = price)) + geom_histogram(binwidth = 10)
ggplot(data = diamonds, mapping = aes(x = price)) + geom_histogram(binwidth = 5)
ggplot(data = diamonds, mapping = aes(x = price)) + geom_histogram(binwidth = 1)

# From low to high prices, the zeta on the distribution falls off crazily quickly, with "cheaper" diamonds having
# much taller bars on the histogram. around $1000 appears to be the most popular price point. Whereas with more
# expensive diamonds, prices appear to be more arbitrary rather than hovering near round numbers.

# 3. How many diamonds are 0.99 carat? How many are 1 carat? What do you think is the cause of the difference?

filter(diamonds, carat %in% c(0.99, 1)) %>%  count(carat)

# There are 23 0.99 carat diamonds and 1558 1.00 carat diamonds. My wild hypothesis: maybe diamond dealers need to
# meet some minimum standard so that when they advertize a diamond as 1 carat, it actually needs to be 1 carat...

# 4. Compare and contrast coord_cartesian() vs xlim() or ylim() when zooming in on a histogram. What happens if you 
# leave binwidth unset? What happens if you try and zoom so only half a bar shows?

ggplot(data = diamonds, mapping = aes(x = price)) + geom_histogram(binwidth = 100)
ggplot(data = diamonds, mapping = aes(x = price)) + geom_histogram(binwidth = 100) + 
  coord_cartesian(xlim = c(100, 1500))
ggplot(data = diamonds, mapping = aes(x = price)) + geom_histogram(binwidth = 100) +
  xlim(100, 1500)

# coord_cartesian() shrinks the size of the cartesian plane in the result's display; it is a visual adjustment; 
# xlim() and ylim() goes a step further in that it also excludes data outside of the argument ranges from being
# displayed entirely.

ggplot(data = diamonds, mapping = aes(x = price)) + geom_histogram()
# When no binwidth is specified, it defaults to 30. The documentation of geom_histogram() says it should always be
# specified, since 30 is an arbitrary default value.

ggplot(data = diamonds, mapping = aes(x = price)) + geom_histogram(binwidth = 5000) + 
  coord_cartesian(xlim = c(2500, 5000))
ggplot(data = diamonds, mapping = aes(x = price)) + geom_histogram(binwidth = 5000) + 
  xlim(2500, 5000)

# Trying to zoom in on half a bar using coord_cartesian() will still show part of the adjacent bar on the edge of the
# graph. However, with xlim() it just shows blank.

# 7.4.1 Exercises -----------------------------------------------------------------------------------------------

# 1. What happens to missing values in a histogram? What happens to missing values in a bar chart? Why is there a 
# difference?

(diamonds3 <- diamonds %>%  filter(y < 3.8) %>% 
   mutate(y = ifelse(y < 3, NA, y), cut = ifelse(y < 3, NA, as.character(cut))))
# limiting diamonds to a tibble of 20 rows, 7 of which have NA values for the cut and y variables

ggplot(data = diamonds3, mapping = aes(x = y)) + geom_histogram(binwidth = 0.5)
# When plotting with geom_histogram(), it removes the 7 NA values for y.

ggplot(data = diamonds3, mapping = aes(x = y)) + geom_bar()
# Same thing with geom_bar(), it removes the 7 NA values for y.

ggplot(data = diamonds3, mapping = aes(x = cut)) + geom_bar()
# However, with a categorical variable like cut, NA is its own category in a bar chart.

# 2. What does na.rm = TRUE do in mean() and sum()?

diamonds3 %>%  summarize(mean_y = mean(y), sum_y = sum(y))
diamonds3 %>%  summarize(mean_y = mean(y, na.rm = TRUE), sum_y = sum(y, na.rm = TRUE))

# It removes the NA values before performing the calculation, and so prevents the result from returning NA.

# 7.5.1.1 Exercises -----------------------------------------------------------------------------------------------

# 1. Use what you've learned to improve the visualisation of the departure times of cancelled vs. non-cancelled flights.

ggplot(data = flights) + geom_boxplot(mapping = aes(x = is.na(dep_time), 
  y = ifelse(is.na(dep_time), sched_dep_time %/% 100 + sched_dep_time %% 100 / 60, dep_time %/% 100 + dep_time %% 100 / 60)))

ggplot(data = flights) +  geom_boxplot(mapping = aes(x = is.na(dep_time), y = sched_dep_time))

# We can see the trend of cancelled flights' scheduled departure times being later than both the actual and scheduled
# departure times of non-cancelled flights. This makes some intuitive sense as cancelled flights can often be delayed
# before they are ultimately cancelled.

# 2. What variable in the diamonds dataset is most important for predicting the price of a diamond? How is that 
#variable  correlated with cut? Why does the combination of those two relationships lead to lower quality diamonds 
# being more expensive?

?diamonds
diamonds2 <- filter(diamonds, between(y, 3, 20))

ggplot(data = diamonds2, mapping = aes(x = carat, y = price)) + 
  geom_point(mapping = aes(color = cut), alpha = 1/10) + 
  geom_smooth(se = FALSE)

ggplot(data = diamonds2, mapping = aes(x = depth, y = price)) + 
  geom_point(mapping = aes(color = cut), alpha = 1/10) + 
  geom_smooth(se = FALSE)

ggplot(data = diamonds2, mapping = aes(x = table, y = price)) + 
  geom_point(mapping = aes(color = cut), alpha = 1/10) + 
  geom_smooth(se = FALSE)

ggplot(data = diamonds2, mapping = aes(x = x, y = price)) + 
  geom_point(mapping = aes(color = cut), alpha = 1/10) + 
  geom_smooth(se = FALSE)

ggplot(data = diamonds2, mapping = aes(x = y, y = price)) + 
  geom_point(mapping = aes(color = cut), alpha = 1/10) + 
  geom_smooth(se = FALSE)

ggplot(data = diamonds2, mapping = aes(x = z, y = price)) + 
  geom_point(mapping = aes(color = cut), alpha = 1/10) + 
  geom_smooth(se = FALSE)

# Looking through the above plots where the horizontal axis was mapped to carat, x, y, and z, it appears that there is 
# a fairly strong relationship between the weight & size of a diamond and its price. It also happens that the heavier 
# and larger diamonds are of a lower quality cut.

# 3. Install the ggstance package, and create a horizontal boxplot. How does this compare to using coord_flip()?

ggplot(data = diamonds2, mapping = aes(y = cut, x = price)) + geom_boxploth()

# Looks like the same thing as regular boxplot plus coord_flip(), just a handy shortcut.

# 4. One problem with boxplots is that they were developed in an era of much smaller datasets and tend to display a 
# prohibitively large number of "outlying values". One approach to remedy this problem is the letter value plot. 
# Install the lvplot package, and try using geom_lv() to display the distribution of price vs cut. What do you learn? 
# How do you interpret the plots?

ggplot(data = diamonds2, mapping = aes(x = cut, y = price)) + geom_lv()

# Uhh, not sure if I'm doing this right because that looks pretty weird. I guess it is a more detailed view than the
# traditional boxplot since we are getting a view of more than just quartiles. Seems like we have a more granular view
# into what is going on around the tails. In this graph, we can see that for any given cut, price skews bottom heavy,
# i.e. higher prices are rarer.

# 5. Compare and contrast geom_violin() with a facetted geom_histogram(), or a coloured geom_freqpoly(). What are the 
# pros and cons of each method?

ggplot(data = mpg) + geom_histogram(mapping = aes(x = displ, color = class), binwidth = 1) + facet_wrap(~ class)
ggplot(data = mpg) + geom_violin(mapping = aes(x = class, y = displ, color = class))
ggplot(data = mpg) + geom_freqpoly(mapping = aes(x = displ, color = class), binwidth = 1, size = 1)

# Faceted histogram - pros: straightforward to interpret, data is easily comparable since the panels are adjacent;
# cons: data is not all in one graph, binwidth is a constraint
# Violin - pros: has the categories alongside each other, is like a density chart or continuous bindwidth histogram;
# cons: looks kinda weird, can be hard to tell the width of the squids relative to each other
# Freqpoly - pros: lines are overlayed on top of each other so it is easy to compare frequencies for any given value;
# cons: not the most intuitive or most aesthetically pleasing view, appears messy when there are many categories

# 6. If you have a small dataset, it's sometimes useful to use geom_jitter() to see the relationship between a 
# continuous and categorical variable. The ggbeeswarm package provides a number of methods similar to geom_jitter(). 
# List them and briefly describe what each one does.

?geom_beeswarm
?geom_quasirandom

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + geom_beeswarm()
# Whaddaya know, looks like a bunch of bees. Deals with overplotting by placing repeat values next to each other.

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + geom_quasirandom()
# Like beeswarm, but (quasi-)randomizes the horizontal offset between repeat-value points.

# There's also position_beeswarm() and position_quasirandom() but I haven't figured out how to use those yet.

# 7.5.2.1 Exercises -----------------------------------------------------------------------------------------------

# 1. How could you rescale the count dataset above to more clearly show the distribution of cut within colour, or 
# colour within cut?

# If showing distro of cut within color, then group by color. Vice versa, group by count. Then calculate the ratios
# instead of the raw counts, and map that to the tile's fill aesthetic.

# Showing distro of cut within color:
diamonds %>% group_by(color) %>% count(color, cut) %>% mutate(pct = n/sum(n)) %>% 
  ggplot(mapping = aes(x = color, y = cut)) + geom_tile(mapping = aes(fill = pct))

# Showing distro of color within cut:
diamonds %>% group_by(cut) %>% count(color, cut) %>% mutate(pct = n/sum(n)) %>% 
  ggplot(mapping = aes(x = color, y = cut)) + geom_tile(mapping = aes(fill = pct))

# 2. Use geom_tile() together with dplyr to explore how average flight delays vary by destination and month of year.
# What makes the plot difficult to read? How could you improve it?

flights %>% filter(is.na(arr_delay) == FALSE) %>% group_by(month, dest) %>% 
  summarize(avg_delay = mean(arr_delay, na.rm = TRUE)) %>% 
  ggplot(mapping = aes(x = month, y = dest)) + geom_tile(aes(fill = avg_delay))

# The number of destinations is too damn high. And the color scheme was chosen by an emo Pablo Picasso.
# I would limit it to a smaller subset of destinations, and choose a non-monochromatic color scale.

# 3. Why is it slightly better to use aes(x = color, y = cut) rather than aes(x = cut, y = color) in the example above?

# Aspect ratio on a horizontal monitor would have made it look weirdly stretched.

# 7.5.3.1 Exercises -----------------------------------------------------------------------------------------------

# 1. Instead of summarising the conditional distribution with a boxplot, you could use a frequency polygon. What do you
# need to consider when using cut_width() vs cut_number()? How does that impact a visualisation of the 2d distribution
# of carat and price?

ggplot(data = diamonds, mapping = aes(x = carat, y = price)) + 
  geom_boxplot(mapping = aes(group = cut_width(carat, 0.1)))
ggplot(data = diamonds, mapping = aes(x = carat, y = price)) + 
  geom_boxplot(mapping = aes(group = cut_number(carat, 20)))

# cut_number() shows how many the range of values that make up each bin, and you knwo that yeach bin has the same
# number of members. But it can look visually displeasing. cut_width() looks nice and uniform, you just have to keep in
# mind that although the bins have equal width, the number of data in each bin can vary.

# 2. Visualise the distribution of carat, partitioned by price.

ggplot(data = diamonds, mapping = aes(x = price, y = carat)) + 
  geom_boxplot(mapping = aes(group = cut_width(price, 1000)))

# 3. How does the price distribution of very large diamonds compare to small diamonds. Is it as you expect, or does it
# surprise you?

# Referring to the boxplots from question 1, yes it somewhat surprises me that there appears to be a larger variation
# in prices of larger diamonds than smaller ones. I would have guessed that there would be a large range in prices for
# small diamonds since there'd be a variety of quality, color, cut, etc. Whereas large diamonds' size would just
# override most other factors and make for a tight spread in price. Looks like I was wrong.

# 4. Combine two of the techniques you've learned to visualise the combined distribution of cut, carat, and price.

ggplot(data = diamonds, mapping = aes(x = price, y = carat, color = cut)) + 
  geom_boxplot(mapping = aes(group = cut_width(price, 1000))) +
  facet_wrap(~ cut)
# Probably not the greatest option, but eh, pretty colors.

# 5. Two dimensional plots reveal outliers that are not visible in one dimensional plots. For example, some points in
# the plot below have an unusual combination of x and y values, which makes the points outliers even though their x and
# y values appear normal when examined separately.

ggplot(data = diamonds) +
  geom_point(mapping = aes(x = x, y = y)) +
  coord_cartesian(xlim = c(4, 11), ylim = c(4, 11))

# Why is a scatterplot a better display than a binned plot for this case?

# Probably because the color gradient is too subtle to tell if a bin has some outliers. A few outliers in a bin is not
# going to have a very noticeable impact on the resulting color of that bin. With scatterplots it's obvious because
# you can see the gap in position in both dimensions.



