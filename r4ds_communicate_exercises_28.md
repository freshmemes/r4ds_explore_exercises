# r4ds_communicate_exercises_28


```r
library(tidyverse)
library(nycflights13)
library(lubridate)
```

## 28.2.1 Exercises

### 1. Create one plot on the fuel economy data with customised `title`, `subtitle`, `caption`, `x`, `y`, and `colour` labels.


```r
ggplot(mpg, aes(displ, hwy, color = drv)) +
  labs(title = "AWD cars tend to have the worst mileage",
       subtitle = "followed by RWD and FWD",
       caption = "Data came with ggplot",
       x = "Displacement",
       y = "Hwy MPG",
       color = "Drive") +
  geom_point() +
  geom_smooth()
```

```
## `geom_smooth()` using method = 'loess'
```

![](r4ds_communicate_exercises_28_files/figure-html/unnamed-chunk-2-1.png)<!-- -->

### 2. The `geom_smooth()` is somewhat misleading because the `hwy` for large engines is skewed upwards due to the inclusion of lightweight sports cars with big engines. Use your modelling tools to fit and display a better model.


```r
ggplot(mpg, aes(displ, hwy, color = class)) +
  labs(title = "2 seaters have decent mileage due to their light chassis",
       subtitle = "They are the exceptions among RWD cars",
       caption = "Data came with ggplot",
       x = "Displacement",
       y = "Hwy MPG",
       color = "Class") +
  geom_point() +
  geom_smooth()
```

```
## `geom_smooth()` using method = 'loess'
```

```
## Warning in simpleLoess(y, x, w, span, degree = degree, parametric =
## parametric, : span too small. fewer data values than degrees of freedom.
```

```
## Warning in simpleLoess(y, x, w, span, degree = degree, parametric =
## parametric, : pseudoinverse used at 5.6935
```

```
## Warning in simpleLoess(y, x, w, span, degree = degree, parametric =
## parametric, : neighborhood radius 0.5065
```

```
## Warning in simpleLoess(y, x, w, span, degree = degree, parametric =
## parametric, : reciprocal condition number 0
```

```
## Warning in simpleLoess(y, x, w, span, degree = degree, parametric =
## parametric, : There are other near singularities as well. 0.65044
```

```
## Warning in predLoess(object$y, object$x, newx = if
## (is.null(newdata)) object$x else if (is.data.frame(newdata))
## as.matrix(model.frame(delete.response(terms(object)), : span too small.
## fewer data values than degrees of freedom.
```

```
## Warning in predLoess(object$y, object$x, newx = if
## (is.null(newdata)) object$x else if (is.data.frame(newdata))
## as.matrix(model.frame(delete.response(terms(object)), : pseudoinverse used
## at 5.6935
```

```
## Warning in predLoess(object$y, object$x, newx = if
## (is.null(newdata)) object$x else if (is.data.frame(newdata))
## as.matrix(model.frame(delete.response(terms(object)), : neighborhood radius
## 0.5065
```

```
## Warning in predLoess(object$y, object$x, newx = if
## (is.null(newdata)) object$x else if (is.data.frame(newdata))
## as.matrix(model.frame(delete.response(terms(object)), : reciprocal
## condition number 0
```

```
## Warning in predLoess(object$y, object$x, newx = if
## (is.null(newdata)) object$x else if (is.data.frame(newdata))
## as.matrix(model.frame(delete.response(terms(object)), : There are other
## near singularities as well. 0.65044
```

```
## Warning in simpleLoess(y, x, w, span, degree = degree, parametric =
## parametric, : pseudoinverse used at 4.008
```

```
## Warning in simpleLoess(y, x, w, span, degree = degree, parametric =
## parametric, : neighborhood radius 0.708
```

```
## Warning in simpleLoess(y, x, w, span, degree = degree, parametric =
## parametric, : reciprocal condition number 0
```

```
## Warning in simpleLoess(y, x, w, span, degree = degree, parametric =
## parametric, : There are other near singularities as well. 0.25
```

```
## Warning in predLoess(object$y, object$x, newx = if
## (is.null(newdata)) object$x else if (is.data.frame(newdata))
## as.matrix(model.frame(delete.response(terms(object)), : pseudoinverse used
## at 4.008
```

```
## Warning in predLoess(object$y, object$x, newx = if
## (is.null(newdata)) object$x else if (is.data.frame(newdata))
## as.matrix(model.frame(delete.response(terms(object)), : neighborhood radius
## 0.708
```

```
## Warning in predLoess(object$y, object$x, newx = if
## (is.null(newdata)) object$x else if (is.data.frame(newdata))
## as.matrix(model.frame(delete.response(terms(object)), : reciprocal
## condition number 0
```

```
## Warning in predLoess(object$y, object$x, newx = if
## (is.null(newdata)) object$x else if (is.data.frame(newdata))
## as.matrix(model.frame(delete.response(terms(object)), : There are other
## near singularities as well. 0.25
```

![](r4ds_communicate_exercises_28_files/figure-html/unnamed-chunk-3-1.png)<!-- -->

### 3. Take an exploratory graphic that you've created in the last month, and add informative titles to make it easier for others to understand.


```r
make_datetime_100 <- function(year, month, day, time) {
  make_datetime(year, month, day, time %/% 100, time %% 100)
}

flights_dt <- flights %>% 
  filter(!is.na(dep_time), !is.na(arr_time)) %>% 
  mutate(
    dep_time = make_datetime_100(year, month, day, dep_time),
    arr_time = make_datetime_100(year, month, day, arr_time),
    sched_dep_time = make_datetime_100(year, month, day, sched_dep_time),
    sched_arr_time = make_datetime_100(year, month, day, sched_arr_time)
  ) %>% 
  select(origin, dest, ends_with("delay"), ends_with("time"))

flights_dt %>% 
  transmute(is_delay = (dep_delay > 0), minute = minute(dep_time)) %>% # create binary dep_delay variable, extract minutes
  group_by(minute) %>% 
  summarize(pct_delay = mean(is_delay, na.rm = T)) %>% # find proportion of flights delayed by minute
  ungroup %>% 
  ggplot(aes(minute, pct_delay)) +
    geom_point() +
    geom_line(aes(group = 1)) +
    labs(title = "Flight departure delays by minute of hour",
         subtitle = "Delays are smaller around 20-30 and 50-60 minute marks",
         x = "% of Flights delayed",
         y = "Minutes delayed",
         caption = "Data from nycflights13 package")
```

![](r4ds_communicate_exercises_28_files/figure-html/unnamed-chunk-4-1.png)<!-- -->

## 28.3.1 Exercises

### 1. Use `geom_text()` with infinite positions to place text at the four corners of the plot.


```r
label <- tibble(
  displ = Inf,
  hwy = Inf,
  label = "Lorem ipsum"
)
label2 <- tibble(
  displ = -Inf,
  hwy = Inf,
  label = "Lorem ipsum"
)
label3 <- tibble(
  displ = -Inf,
  hwy = -Inf,
  label = "Lorem ipsum"
)
label4 <- tibble(
  displ = Inf,
  hwy = -Inf,
  label = "Lorem ipsum"
)

ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  geom_text(aes(label = label), data = label, vjust = "top", hjust = "right")
```

![](r4ds_communicate_exercises_28_files/figure-html/unnamed-chunk-5-1.png)<!-- -->

```r
ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  geom_text(aes(label = label), data = label2, vjust = "top", hjust = "left")
```

![](r4ds_communicate_exercises_28_files/figure-html/unnamed-chunk-5-2.png)<!-- -->

```r
ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  geom_text(aes(label = label), data = label3, vjust = "bottom", hjust = "left")
```

![](r4ds_communicate_exercises_28_files/figure-html/unnamed-chunk-5-3.png)<!-- -->

```r
ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  geom_text(aes(label = label), data = label4, vjust = "bottom", hjust = "right")
```

![](r4ds_communicate_exercises_28_files/figure-html/unnamed-chunk-5-4.png)<!-- -->

### 2. Read the documentation for `annotate()`. How can you use it to add a text label to a plot without having to create a tibble?

By passing it `geom_text` and its x and y positions as arguments.

### 3. How do labels with `geom_text()` interact with faceting? How can you add a label to a single facet? How can you put a different label in each facet? (Hint: think about the underlying data.)

Something like this.


```r
label5 <- tibble(
  displ = 4,
  hwy = 40,
  label = "Lorem ipsum",
  drv = factor("r", levels = c("f", "r", "4"))
)

ggplot(mpg, aes(displ, hwy)) +
  labs(title = "AWD cars tend to have the worst mileage",
       subtitle = "followed by RWD and FWD",
       caption = "Data came with ggplot",
       x = "Displacement",
       y = "Hwy MPG") +
  geom_point() +
  facet_grid(.~drv) +
  geom_text(aes(label = label), data = label5, vjust = "top", hjust = "right")
```

![](r4ds_communicate_exercises_28_files/figure-html/unnamed-chunk-6-1.png)<!-- -->

### 4. What arguments to `geom_label()` control the appearance of the background box?

`fill`, `color`, `fontface`, etc. within `aes`

### 5. What are the four arguments to `arrow()`? How do they work? Create a series of plots that demonstrate the most important options.

`angle` controls where the arrowhead is pointing. `length` controls how long the arrowhead is. `ends` controls how many heads the arrow has. `type` controls whether the arrowhead is open or closed.


```r
ggplot(mpg, aes(displ, hwy)) +
  geom_point() + 
  geom_segment(aes(x=4, y=30, xend=8, yend=40), arrow = arrow(angle = 30, length = unit(0.25, "inches"),
      ends = "last", type = "open"))
```

![](r4ds_communicate_exercises_28_files/figure-html/unnamed-chunk-7-1.png)<!-- -->

## 28.4.4 Exercises

### 1. Why doesn't the following code override the default scale?


```r
df <- tibble(
  x = rnorm(10000),
  y = rnorm(10000)
)

ggplot(df, aes(x, y)) +
  geom_hex() +
  scale_colour_gradient(low = "white", high = "red") +
  coord_fixed()
```

```
## Warning: package 'hexbin' was built under R version 3.2.5
```

![](r4ds_communicate_exercises_28_files/figure-html/unnamed-chunk-8-1.png)<!-- -->

Is the answer that we were expecting the image that results from using `scale_fill_gradient`?

### 2. What is the first argument to every scale? How does it compare to `labs()`?

`...`, which is flexible just like in `labs()`

### 3. Change the display of the presidential terms by:

#### 1. Combining the two variants shown above.


```r
presidential %>%
  mutate(id = 33 + row_number()) %>%
  ggplot(aes(start, id, colour = party)) +
    geom_point() +
    geom_segment(aes(xend = end, yend = id)) +
    scale_colour_manual(values = c(Republican = "red", Democratic = "blue")) +
    scale_x_date(NULL, breaks = presidential$start, date_labels = "'%y")
```

![](r4ds_communicate_exercises_28_files/figure-html/unnamed-chunk-9-1.png)<!-- -->

#### 2. Improving the display of the y axis.


```r
presidential %>%
  mutate(id = 33 + row_number()) %>%
  ggplot(aes(start, id, colour = party)) +
    geom_point() +
    geom_segment(aes(xend = end, yend = id)) +
    scale_colour_manual(values = c(Republican = "red", Democratic = "blue")) +
    scale_x_date(NULL, breaks = presidential$start, date_labels = "'%y") +
    scale_y_continuous(breaks = seq(34, 44, by = 1))
```

![](r4ds_communicate_exercises_28_files/figure-html/unnamed-chunk-10-1.png)<!-- -->

#### 3. Labelling each term with the name of the president.


```r
presidential %>%
  mutate(id = 33 + row_number()) %>%
  ggplot(aes(start, id, colour = party)) +
    geom_point() +
    geom_segment(aes(xend = end, yend = id)) +
    scale_colour_manual(values = c(Republican = "red", Democratic = "blue")) +
    scale_x_date(NULL, breaks = presidential$start, date_labels = "'%y") +
    scale_y_continuous(breaks = seq(34, 44, by = 1)) +
    geom_text(aes(label = presidential$name), nudge_x = 3, nudge_y = 0.3)
```

![](r4ds_communicate_exercises_28_files/figure-html/unnamed-chunk-11-1.png)<!-- -->

```r
# why is nudge_x not doing anything REEEEEEEEEEEEEEEEEEEEEEEEEE
```

#### 4. Adding informative plot labels.


```r
presidential %>%
  mutate(id = 33 + row_number()) %>%
  ggplot(aes(start, id, colour = party)) +
    geom_point() +
    geom_segment(aes(xend = end, yend = id)) +
    scale_colour_manual(values = c(Republican = "red", Democratic = "blue")) +
    scale_x_date(NULL, breaks = presidential$start, date_labels = "'%y") +
    scale_y_continuous(breaks = seq(34, 44, by = 1)) +
    geom_text(aes(label = presidential$name), nudge_x = 3, nudge_y = 0.3) +
    labs(x = "Year", y = "nth President", title = "Presidential Terms from Eisenhower to Obama")
```

![](r4ds_communicate_exercises_28_files/figure-html/unnamed-chunk-12-1.png)<!-- -->

```r
# why is the x axis label not appearing REEEEEEEEEEEEEEEEEEEEEEEEEE
```

#### 5. Placing breaks every 4 years (this is trickier than it seems!).


```r
presidential %>%
  mutate(id = 33 + row_number(), 
         start2 = as.numeric(year(start)),
         end2 = as.numeric(year(end))) %>%
  ggplot(aes(start2, id, colour = party)) +
    geom_point() +
    geom_segment(aes(xend = end2, yend = id)) +
    scale_colour_manual(values = c(Republican = "red", Democratic = "blue")) +
    scale_x_continuous(breaks = seq(1952, 2016, by = 4)) +
    scale_y_continuous(breaks = seq(34, 44, by = 1)) +
    geom_text(aes(label = presidential$name), nudge_x = 3, nudge_y = 0.3) +
    labs(x = "Year", y = "nth President", title = "Presidential Terms from Eisenhower to Obama")
```

![](r4ds_communicate_exercises_28_files/figure-html/unnamed-chunk-13-1.png)<!-- -->

### 4. Use `override.aes` to make the legend on the following plot easier to see.


```r
ggplot(diamonds, aes(carat, price)) +
  geom_point(aes(colour = cut), alpha = 1/20) + 
  guides(colour = guide_legend(override.aes = list(alpha = 1)))
```

![](r4ds_communicate_exercises_28_files/figure-html/unnamed-chunk-14-1.png)<!-- -->
