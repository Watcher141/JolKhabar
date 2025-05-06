/**
 * JolKhabar Search Functionality
 */
document.addEventListener('DOMContentLoaded', function() {
    // Get search elements
    const searchInput = document.getElementById('search-input');
    const searchButton = document.getElementById('search-button'); // Will be hidden but kept for reference
    const searchResults = document.getElementById('search-results');
    
    // Check if we're in a product page or homepage (for correct image path handling)
    const isProductPage = window.location.href.includes('/Products/');
    const imagePath = isProductPage ? '../' : './';
    const fallbackImage = isProductPage ? '../Assets/jolkhabr.png' : './Assets/jolkhabr.png';
    
    // Create page transition overlay
    const pageTransition = document.createElement('div');
    pageTransition.className = 'page-transition';
    document.body.appendChild(pageTransition);
    
    // Create mobile search bar for small screens
    if (window.innerWidth <= 480) {
        // Remove any existing mobile search bars to avoid duplicates
        const existingMobileSearch = document.querySelector('.search-container-mobile');
        if (!existingMobileSearch) {
            createMobileSearchBar();
        }
    }
    
    // We'll still attach event listener to search button if it exists, for backward compatibility
    if (searchButton) {
        searchButton.addEventListener('click', function() {
            performSearch();
        });
    }
    
    // Add input field event listeners - these are now more important since there's no button
    if (searchInput) {
        searchInput.addEventListener('keyup', function(event) {
            if (event.key === 'Enter') {
                performSearch();
            } else if (searchInput.value.length >= 2) {
                // Auto-search after typing at least 2 characters
                performSearch();
            } else if (searchInput.value.length === 0) {
                hideSearchResults();
            }
        });
        
        // Focus on search input when clicked
        searchInput.addEventListener('focus', function() {
            if (searchInput.value.length >= 2) {
                performSearch();
            }
        });
    }
    
    // Hide results when clicking elsewhere
    document.addEventListener('click', function(event) {
        if (!event.target.closest('.search-container') && !event.target.closest('.search-container-mobile')) {
            hideSearchResults();
            hideSearchResultsMobile();
        }
    });
    
    // Create mobile search bar
    function createMobileSearchBar() {
        // Check if mobile search already exists
        if (document.querySelector('.search-container-mobile')) {
            return;
        }
        
        const mobileSearchContainer = document.createElement('div');
        mobileSearchContainer.className = 'search-container-mobile';
        
        const mobileSearchInput = document.createElement('input');
        mobileSearchInput.type = 'text';
        mobileSearchInput.id = 'search-input-mobile';
        mobileSearchInput.placeholder = 'Search products...';
        
        const mobileSearchResults = document.createElement('div');
        mobileSearchResults.id = 'search-results-mobile';
        
        mobileSearchContainer.appendChild(mobileSearchInput);
        mobileSearchContainer.appendChild(mobileSearchResults);
        
        // Add mobile search container as the first child of body
        if (document.body.firstChild) {
            document.body.insertBefore(mobileSearchContainer, document.body.firstChild);
        } else {
            document.body.appendChild(mobileSearchContainer);
        }
        
        // Add event listeners for mobile search
        mobileSearchInput.addEventListener('keyup', function(event) {
            if (event.key === 'Enter') {
                performSearchMobile();
            } else if (mobileSearchInput.value.length >= 2) {
                // Auto-search after typing at least 2 characters
                performSearchMobile();
            } else if (mobileSearchInput.value.length === 0) {
                hideSearchResultsMobile();
            }
        });
        
        // Focus on mobile search input when clicked
        mobileSearchInput.addEventListener('focus', function() {
            if (mobileSearchInput.value.length >= 2) {
                performSearchMobile();
            }
        });
    }
    
    // Main search function
    function performSearch() {
        if (!searchInput) return;
        
        const query = searchInput.value.toLowerCase().trim();
        
        if (query.length === 0) {
            hideSearchResults();
            return;
        }
        
        // Filter products based on search query
        const results = products.filter(product => {
            return product.name.toLowerCase().includes(query) || 
                   product.description.toLowerCase().includes(query) ||
                   product.category.toLowerCase().includes(query);
        });
        
        // Display search results
        displayResults(results, query, searchResults);
        
        // Track search for analytics
        trackSearch(query);
    }
    
    // Mobile search function
    function performSearchMobile() {
        const mobileSearchInput = document.getElementById('search-input-mobile');
        if (!mobileSearchInput) return;
        
        const query = mobileSearchInput.value.toLowerCase().trim();
        
        if (query.length === 0) {
            hideSearchResultsMobile();
            return;
        }
        
        // Filter products based on search query
        const results = products.filter(product => {
            return product.name.toLowerCase().includes(query) || 
                   product.description.toLowerCase().includes(query) ||
                   product.category.toLowerCase().includes(query);
        });
        
        // Display search results
        const mobileSearchResults = document.getElementById('search-results-mobile');
        displayResults(results, query, mobileSearchResults);
        
        // Track search for analytics
        trackSearch(query);
    }
    
    // Display search results - updated to work with both desktop and mobile
    function displayResults(results, query, resultsContainer) {
        if (!resultsContainer) return;
        
        resultsContainer.innerHTML = '';
        
        if (results.length === 0) {
            resultsContainer.innerHTML = '<div class="no-results">No products found matching your search</div>';
            resultsContainer.style.display = 'block';
            return;
        }
        
        // Create a result item for each matching product
        results.forEach(product => {
            const resultItem = document.createElement('div');
            resultItem.className = 'search-result-item';
            
            // Highlight matching text
            const nameHighlighted = highlightText(product.name, query);
            const descHighlighted = highlightText(product.description, query);
            
            // Fix image paths based on whether we're in product page or homepage
            let imageSrc = product.image;
            if (isProductPage && !imageSrc.startsWith('../')) {
                imageSrc = '../' + imageSrc;
            }
            
            // Get the correct product detail URL
            let detailsUrl = product.detailsUrl;
            if (isProductPage && detailsUrl.startsWith('./')) {
                detailsUrl = '.' + detailsUrl;
            }
            
            resultItem.innerHTML = `
                <img src="${imageSrc}" alt="${product.name}" onerror="this.src='${fallbackImage}'">
                <div class="search-result-item-content">
                    <h3>${nameHighlighted}</h3>
                    <p>${descHighlighted}</p>
                    <span class="category">${product.category}</span>
                </div>
            `;
            
            // Add click event to navigate to product detail page with animation
            resultItem.addEventListener('click', function(e) {
                e.preventDefault();
                
                // Show the transition overlay
                pageTransition.classList.add('active');
                
                // Navigate to new page after animation
                setTimeout(function() {
                    window.location.href = detailsUrl;
                }, 400); // Match this with the CSS animation duration
            });
            
            resultsContainer.appendChild(resultItem);
        });
        
        // Display search results
        resultsContainer.style.display = 'block';
    }
    
    // Highlight search term in text
    function highlightText(text, query) {
        if (!query || query.length < 2) return text;
        
        const escapedQuery = query.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&');
        const regex = new RegExp(`(${escapedQuery})`, 'gi');
        return text.replace(regex, '<span class="highlight">$1</span>');
    }
    
    // Hide search results
    function hideSearchResults() {
        if (searchResults) {
            searchResults.style.display = 'none';
        }
    }
    
    // Hide mobile search results
    function hideSearchResultsMobile() {
        const mobileSearchResults = document.getElementById('search-results-mobile');
        if (mobileSearchResults) {
            mobileSearchResults.style.display = 'none';
        }
    }
    
    // Track search analytics using localStorage
    function trackSearch(query) {
        if (window.localStorage) {
            // Create or retrieve search history
            let searchHistory = JSON.parse(localStorage.getItem('jolkhabarSearchHistory') || '[]');
            
            // Add this search with timestamp
            searchHistory.push({
                query: query,
                timestamp: new Date().toISOString()
            });
            
            // Keep only last 100 searches
            if (searchHistory.length > 100) {
                searchHistory = searchHistory.slice(-100);
            }
            
            // Save back to localStorage
            localStorage.setItem('jolkhabarSearchHistory', JSON.stringify(searchHistory));
        }
    }
    
    // Add window resize event to handle switching between desktop and mobile
    window.addEventListener('resize', function() {
        if (window.innerWidth <= 480) {
            // If mobile view and no mobile search exists
            if (!document.querySelector('.search-container-mobile')) {
                createMobileSearchBar();
            }
        }
    });
});