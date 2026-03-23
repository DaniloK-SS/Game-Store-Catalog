# Game Store Catalog

# -- Project Description--
Game Store Catalog is a small catalog-style web application built with Next.js, React, and TypeScript.

The application allows users to browse a list of video games, search by title, filter by platform and genre, sort results, and open a dedicated page with detailed information about each game.
The main goal of this project is to practice:

1.building reusable React components

2.working with catalog-style UI layouts

3.implementing search, filters, and sorting

4.working with dynamic routes in Next.js

# Features
The application includes the following functionality:
* Browse a list of games
* Search games by title
* Filter games by platform,genre,by stock availability
* Sort games by price, title, or release year
* View a detailed page for each game
* Handle empty results when filters return no games
* Responsive design (mobile + desktop)
* Wishlist system (stored in localStorage)

Technologies Used(frontend Danilo)

* Next.js (App Router)
* React
* TypeScript

# --------------Folder Structure ----------------

The project is organized into several folders to keep the code modular and maintainable.

Pages
# Games Page
route:
app/games 
# This page displays the full catalog of games.

Game Details Page
Route:
app/games/[id]
# This page displays detailed information about a specific game.

Wishlist
route:
app/wishlist
# This page display the wishlist.

# Components
GameCard
route:
components/GameCard.tsx
# represents a single game item in the catalog(display:game cover image,game title,platform,genre,price,stock status).
GameGrid
route:
components/GameGrid.tsx
# responsible for rendering a grid layout of multiple games.
SearchBar
route:
components/SearchBar.tsx
# allows users to search games by title
FilterPanel
route:
components/FilterPanel.tsx
# contains the UI for filtering the catalog
Navbar
route:
components/Navbar.tsx
# provides the main navigation for the application.
EmptyState
route:
components/EmptyState.tsx
# used to display small status indicators
SortSelect
route:
components/SortSelect.tsx
# provides sorting options for the games list
EmptyWishlist.tsx
route:
components/EmptyWishlist.tsx.

* ----------Application Logic---------- 

The games list displayed in the catalog is derived from the original data by applying:

search filtering

platform filtering

genre filtering

stock filtering

sorting
# Empty State Handling
If no games match the selected filters or search query, the application displays an appropriate message indicating that no results were found.

# Learning Goals
This project focuses on practicing core frontend development concepts such as:
* reusable component architecture
* data-driven UI rendering
* combining multiple filters
* sorting collections
* dynamic routing with Next.js
 # Notes
- Wishlist is implemented using **localStorage**
- Focus is on UI logic and component architecture

- 👨‍💻 Author
Frontend: **Danilo**