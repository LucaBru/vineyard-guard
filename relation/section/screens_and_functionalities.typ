#import "../config/variable.typ": app, chapter_vertical_space, sub_chapter_space,

= Screen and functionalities
#chapter_vertical_space

#app is made of 4 different screens: treatments, purchases, warehouse and weather. Bottom navigation bar is provided for navigation among screens, even in android, since nowadays is common despite the possible presence of operating system navigation bar.
Moreover the implementation of and hamburger menu was not on my schedule during development due to time constraints.

== Pesticide purchases screen
#sub_chapter_space
#grid(
  columns: (1fr, 1fr, 1fr),
  rows: auto,
  align: center,
  gutter: 2%,
  grid.cell(image("../images/purchase_screen.jpg", height: 40%)),
    grid.cell(image("../images/dismiss_purchase.jpg", height: 40%)),
  grid.cell(image("../images/empty_purchase_screen.jpg", height: 40%)),
)


This screen displays all pesticide purchases as a list of cards, with each card representing a purchase and showing the pesticide name, quantity, and price.
In the case where there aren't purchases an empty box with an error message is showed.

Purchases of the same pesticide are treated independently to keep management simple. Pesticide names are case-sensitive to avoid user confusion and ensure precise tracking: it means that names with different upper or lower case characters identify different pesticides.

Purchases can be added using the floating action button, with a form that requires the pesticide name, price, amount, and unit of measure (kilograms or liters). Unit of measure selection is a perfect candidate for radio button since there are only 2 possibilities and it removes unnecessary clicks speeding up the whole process.

To remove a purchase, simply swipe it away. This swipe-to-remove functionality is consistent throughout the application improving ease of use (it removes unnecessary tap or click) and accessibility (it requires less precision).

#pagebreak()
== Treatments screen
#sub_chapter_space
#grid(
  columns: (1fr, 1fr, 1fr),
  rows: auto,
  align: center,
  gutter: 2%,
  grid.cell(image("../images/treatment_screen.jpg", height: 40%)),
  grid.cell(image("../images/expanded_treatment.jpg", height: 40%)),
  grid.cell(image("../images/empty_treatment_screen.jpg", height: 40%)),
)

This screen displays all treatments as a list of cards, each uniquely identified by its date.
Tapping a card reveals more information about the treatment, including all pesticides used and their quantities. Expanded treatment has different colors to highlight itself among the others.
During development expanded card was choosed over a more datailed screen since the informations to show per each treatment are limited and in this way no additional layer of depth is added, gaining in easy of useness.

As mentioned above, to delete a treatment, just swipe it away.

Treatments can be shared as pdf file using the share button in the header.
The generated pdf contains a table where each treatment is a row with date as first column and pesticides used with relative quantities as second column.
In this way the agronomist that follows the farm throughout the year can suggest the right pesticides and timing for next treatments to minimize the risk of diseases and reduce waste.

#pagebreak()
=== Insert treatment form
#sub_chapter_space
#grid(
  columns: (1fr, 1fr, 1fr),
  rows: (auto, auto),
  align: center,
  gutter: 2%,
  grid.cell(image("../images/treatment_form.jpg", height: 40%)),
  grid.cell(image("../images/dismiss_treatment_form.jpg", height: 40%)),
  grid.cell(image("../images/multiple_pesticide_error_treatment_form.jpg", height: 40%)),
  grid.cell(image("../images/available_pesticide_error.jpg", height: 40%)),
  grid.cell(image("../images/empty_treatment_form.jpg", height: 40%)),
)

You can add a treatment using the floating button by specifying the date and the pesticides used.
Date selection is made by the date picker and the current date is provided as default, since the use case scenario supposes that the operator adds the treatment right after its executions.
Pesticides used in treatments must be selected among the ones that are available in the warehouse. This operation is implemented via drop down search menu: the search functionality is added due to the possible hight number of pesticides available. Indeed the user doesn't have to scroll the entire list to find the right pesticide, it sufficient to search its.
While adding pesticides to treatment a list of pesticides used is build under the add button to keep track and manage them.
Pesticides available in the warehouse correspond to those purchased and not yet fully used in previous treatments.
The creation of a dynamic list using a form is not a simple design task, anyway the final result trys to take down complexity and be as simple and direct as possible.
The section of the form for selecting pesticides used is divided by lines to highlight the fact that it is a sub-part of the main form.
Other possible design solution for this form (like moving it one step further in depth) were discarded during development since they arise the overlall complexity and are less intuitive than the final one. 

If you try to add more than stocked or add a treatment without selecting any pesticide, an error message is displayed. 
Obviously if you try to add a treatment with no pesticide purchased, so with no pesticide available in the warehouse the app shows you an empty box and suggest you to purchase some pesticides.

Multiple instances of the same pesticide are not allowed to keep the process simple.

#pagebreak()
== Warehouse screen
#sub_chapter_space
#align(center, image("../images/warehouse_screen.jpg", height: 40%))

#app doesn’t only track treatments, it also tracks purchases. This screen lists the pesticides available in the warehouse, showing the amount purchased and the amount used. The goal of this screen is to keep track of the warehouse status, ensuring timely notifications to suppliers to avoid delays.

To do so in the most efficient way a pie chart is provided, where each slide represent a stocked pestice in the warehouse.
Pie chart only creates a visual representation of the list of stocked pesticides that is below, so the talkback gives to the user only a brief description rather than the entire information.

This information is read-only, as it depends on purchases and treatments, so users cannot discard any cards from this screen.

#pagebreak()
== Weather screen
#sub_chapter_space
#grid(
  columns: (1fr, 1fr, 1fr),
  rows: auto,
  align: center,
  gutter: 2%,
  grid.cell(image("../images/weather_1.jpg", height: 40%)),
  grid.cell(image("../images/weather_2.jpg", height: 40%)),
  grid.cell(image("../images/weather_error.jpg", height: 40%)),
)

The frequency of treatments depends on precipitation and temperature since diseases are influenced by these factors. This screen shows weather information since the last treatment (with an upper limit of 14 days), if the difference between such date and the current is less than one day, then an error message is displayed. 


As for the whole app, this screen display information on cards, one for each average statistics and one for each charts.
Charts are accessible, therefore talk back explains the entire content after a short initial description.

This screen helps the farm better schedule the next treatment and select appropriate pesticides based on the weather conditions.

#pagebreak()
== Theme
#sub_chapter_space
#grid(
  columns: (1fr, 1fr),
  rows: auto,
  align: center,
  gutter: 2%,
  grid.cell(image("../images/expanded_treatment.jpg", height: 40%)),
  grid.cell(image("../images/light_theme.jpg", height: 40%)),
)
Nowadays is not reasonable that an application misses light or dark theme. 
#app use theme selected from the device.
