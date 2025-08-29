# Demoliserh Trains

This mod adds Demolishers as trains.

USE AT YOUR OWN RISK! The mod creator denies all liability if the user experiences a sudden stroke when confusing a Demolisher Train for an actual Demolisher!

_Why this mod_
So there is Biter Captivity which enslaves the Nauvis natives and there is Bio Chambers which enslaves the Gleba natives. Why not enslave the Vulcanus natives as well?

_About the mechanics behind this mod_
In order to display the train in a visually pleasing way we need to cheat the render engine. The default render order is from left to right, bottom to top. This means that if the train is facing the wrong way the segments do not overlap correctly and this just looks ugly. Therefore we add an overlay image on top of each carriage in the demolisher train, which needs to be matched to the position and rotation of that carriage. The engine adds a correction on the carriage's position and rotation to match the train tracks, which leads to a small mismatch in our overlay picture to the actual carriage.

---

# Known issues

-   Animation overlay is not perfectly aligned with the actual entities
-   Possible performance impact due to large number of animations to be updated each tick
-   Possible lag in updating animation overlay due to large number of animations to be updated each tick
-   Possible incompatibility with mods that add a fuel category to Tungsten Ore
-   Possible incompatibility with mods that mess with train lengths
-   Not tested in combination with other mods

# Future ideas

-   Maybe add specific train tracks that go over lava
-   Maybe improve the lava trail and smoke/particle generation

# Collaborations welcome

-   Start a discussion with your ideas
-   Report issues under discussions
