# Yintong-masters

Modified *randomForest predict function* to produce ```.csv``` probability outputs of both **occupancy** and **abundance** category randomForest models.

```.csv``` outputs represent high resolution (1km2) monthly predicted maps. 

| var name  | description                                                                                            |
|-----------|--------------------------------------------------------------------------------------------------------|
| **r**     | data point row index                                                                                   |
| **c**     | data point column index                                                                                |
| **OC0**   | Occupancy model probability of absence                                                                 |
| **OC1**   | Occupancy model probability of presence                                                                |
| **AC1-5** | Abundance Category model. Each column contains the probability associated with each abundance category |
