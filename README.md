<p align="center">
  <img src="https://imgur.com/DauGuwI.png" width="350px">
</p>
<h2 align="center">The Movie Tracker</h2>

A Flutter Application where you can track all the movies you have watched

## Features
- Simple and Intuitive
- Add any Movie with Movie Name, Director Name(optional) and a Movie Poster from your gallery
- View a list of all the movies that you have added
- Update or Remove any movie at any moment
- Blazing fast login using your Google Account
- Multi-User Movie tracking available
- Snappy Read and Writes since all data is kept offline

## Codebase
- Uses Google OAuth for Authentication
- Uses Hive as a on-device NoSQL database

## Future Scope
- [ ] Backup data onto firestore asynchronously
- [ ] Implement a Search functionality
- [ ] Use an API to fetch Movie details and Posters when only Movie Name is provided (possible IMDb API) 
- [ ] Implement segretaion of movies by **Watched** and **Unwatched** 
- [ ] Connect to FireStore for cloud backups