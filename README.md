![alt text](https://www.sharetee.org/RaeDev/mytaxiplusuiboardlightmode.png)
# Taxi Driver 

### Our Goal
An iOS app for the Taxi drivers to help them easily find their customer. Its just a Proof-Of-Concept (POC) version of the the app to test our idea with some of the drivers first.

### Installation Guide
 - After cloning the repository you need to run the following command in terminal (In your project directory). 
    - pod install
 
 - In the first time run with simulator, to get your location you need to set default location to MyLocation in EditScheme -> Options.
 - You can also change default location coordinate in Resources -> MyLocation.gpx file.

### What You Will See
- Authentication using Google Sign In.
- See customers list order by distance from your current location.
- Real time search customers by their name.
- When you tap the customer, the list show mapview with two marker one is your current location and second is customer location.
- In profile, you will see current user information and logout section.
