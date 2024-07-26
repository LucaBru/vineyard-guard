#import "../config/variable.typ": app, chapter_vertical_space, sub_chapter_space


= Introduction
#chapter_vertical_space

== Project overview
#sub_chapter_space
Tracking phytosanitary treatments in vineyards is essential to mitigate the risks of vine diseases and to promote sustainable wine production. This approach helps reduce waste and fosters greater respect for nature.

The lack of an easy and direct way to track these treatments leds to the creation of #app, an application designed to manage pesticides used in farming.
#app supports farmers from the start to the end, from the purchases of pesticide to its consumptions.

More in details, #app enables you to:
- Maintain a list of completed treatments, which can be shared with your agronomist.
- Track pesticide purchases to continuously monitor costs.
- Monitor warehouse stocks to ensure timely replenishment.
- Monitor weather conditions since the last treatment to schedule the next intervention.
The app is tailored for family businesses and does not require user management.
Nevertheless data are stored in _Firestore_, therefore the application can be used in multiple devices.

== Flutter
#sub_chapter_space

Flutter is an open-source UI software development kit (SDK) created by Google. It allows developers to build natively compiled applications for mobile (iOS and Android), web, and desktop from a single codebase. Essentially, this means you can write one codebase and deploy it across multiple platforms, saving time and resources.

Pros of Flutter development:
- *Rapid development*: Flutter's hot reload feature allows for quick UI updates without restarting the app, significantly accelerating development cycles.
- *Beautiful and customizable UI*: Flutter provides a rich set of customizable widgets, enabling developers to create stunning and visually appealing apps.

- *Cost-effective*: Developing a single codebase for multiple platforms can lead to substantial cost savings.
- *Large and growing community*: Flutter has a thriving community, offering extensive support, resources, and third-party packages.
- *Open-source*: Being open-source, Flutter is free to use and contributes to a collaborative development environment.

Cons:
- *Large app size*: Flutter apps tend to be larger than native apps, which can be a concern for users with limited storage.