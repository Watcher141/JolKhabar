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

    // Event listener for when the page is shown (e.g., on load, or when navigating back)
    window.addEventListener('pageshow', function(event) {
        // Ensure the transition is not active when the page is displayed
        if (pageTransition) {
            pageTransition.classList.remove('active');
        }
    });
    
    // SECURITY: Add sanitization function for XSS protection
    function sanitizeHTML(text) {
        const element = document.createElement('div');
        element.textContent = text;
        return element.innerHTML;
    }
    
    // SECURITY: Helper function to escape special characters in regex
    function escapeRegExp(string) {
        return string.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
    }
    
    // SECURITY: Add rate limiting for search
    const MAX_SEARCHES_PER_MINUTE = 30;
    const searches = [];
    
    function checkRateLimit() {
        const now = Date.now();
        
        // Add current search timestamp
        searches.push(now);
        
        // Remove searches older than 1 minute
        while (searches.length && searches[0] < now - 60000) {
            searches.shift();
        }
        
        // Check if too many searches
        if (searches.length > MAX_SEARCHES_PER_MINUTE) {
            console.warn("Search rate limit exceeded");
            return false;
        }
        
        return true;
    }
    
    // Filter out products that don't have actual product detail pages
    const availableProducts = products.filter(product => {
        // Filter out any products with coming-soon.html in their URL
        if (product.detailsUrl.includes('coming-soon.html')) {
            return false;
        }
        
        // Explicitly check the IDs of products we know don't have detail pages yet
        const unavailableProductIds = [6, 7, 22, 32, 38]; // IDs of products without detail pages
        if (unavailableProductIds.includes(product.id)) {
            return false;
        }
        
        return true;
    });
    
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
        
        // SECURITY: Apply rate limiting
        if (!checkRateLimit()) {
            return;
        }
        
        const query = searchInput.value.toLowerCase().trim();
        
        if (query.length === 0) {
            hideSearchResults();
            return;
        }
        
        // SECURITY: Sanitize the search query
        const sanitizedQuery = sanitizeHTML(query);
        
        // Filter products based on search query - Only from available products
        const results = availableProducts.filter(product => {
            return product.name.toLowerCase().includes(sanitizedQuery) || 
                   product.description.toLowerCase().includes(sanitizedQuery) ||
                   product.category.toLowerCase().includes(sanitizedQuery);
        });
        
        // Display search results
        displayResults(results, sanitizedQuery, searchResults);
        
        // Track search for analytics
        trackSearch(sanitizedQuery);
    }
    
    // Mobile search function
    function performSearchMobile() {
        const mobileSearchInput = document.getElementById('search-input-mobile');
        if (!mobileSearchInput) return;
        
        // SECURITY: Apply rate limiting
        if (!checkRateLimit()) {
            return;
        }
        
        const query = mobileSearchInput.value.toLowerCase().trim();
        
        if (query.length === 0) {
            hideSearchResultsMobile();
            return;
        }
        
        // SECURITY: Sanitize the search query
        const sanitizedQuery = sanitizeHTML(query);
        
        // Filter products based on search query - Only from available products
        const results = availableProducts.filter(product => {
            return product.name.toLowerCase().includes(sanitizedQuery) || 
                   product.description.toLowerCase().includes(sanitizedQuery) ||
                   product.category.toLowerCase().includes(sanitizedQuery);
        });
        
        // Display search results
        const mobileSearchResults = document.getElementById('search-results-mobile');
        displayResults(results, sanitizedQuery, mobileSearchResults);
        
        // Track search for analytics
        trackSearch(sanitizedQuery);
    }
    
    // Display search results - updated to work with both desktop and mobile and now with improved security
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
            
            // SECURITY: Sanitize product data
            const safeName = sanitizeHTML(product.name);
            const safeDesc = sanitizeHTML(product.description);
            const safeCategory = sanitizeHTML(product.category);
            
            // Highlight matching text with improved security
            const nameHighlighted = highlightText(safeName, query);
            const descHighlighted = highlightText(safeDesc, query);
            
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
            
            // SECURITY: Use DOM methods instead of innerHTML where possible
            const img = document.createElement('img');
            img.src = imageSrc;
            img.alt = safeName;
            img.onerror = function() { this.src = fallbackImage; };
            
            const content = document.createElement('div');
            content.className = 'search-result-item-content';
            
            const title = document.createElement('h3');
            title.innerHTML = nameHighlighted; // We use innerHTML here because it contains our highlight spans
            
            const desc = document.createElement('p');
            desc.innerHTML = descHighlighted; // We use innerHTML here because it contains our highlight spans
            
            const categorySpan = document.createElement('span');
            categorySpan.className = 'category';
            categorySpan.textContent = safeCategory;
            
            content.appendChild(title);
            content.appendChild(desc);
            content.appendChild(categorySpan);
            
            resultItem.appendChild(img);
            resultItem.appendChild(content);
            
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
    
    // Highlight search term in text with improved security
    function highlightText(text, query) {
        if (!query || query.length < 2) return text;
        
        // SECURITY: Escape special regex characters in the query to prevent regex injection
        const escapedQuery = escapeRegExp(query);
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
    
    // Track search analytics using localStorage with improved security
    function trackSearch(query) {
        if (window.localStorage) {
            try {
                // SECURITY: Sanitize before storing
                const sanitizedQuery = query.replace(/[<>]/g, '');
                
                // Create or retrieve search history
                let searchHistory = JSON.parse(localStorage.getItem('jolkhabarSearchHistory') || '[]');
                
                // Add this search with timestamp
                searchHistory.push({
                    query: sanitizedQuery,
                    timestamp: new Date().toISOString()
                });
                
                // Keep only last 100 searches
                if (searchHistory.length > 100) {
                    searchHistory = searchHistory.slice(-100);
                }
                
                // Save back to localStorage
                localStorage.setItem('jolkhabarSearchHistory', JSON.stringify(searchHistory));
            } catch (e) {
                console.error('Error processing search history');
                localStorage.removeItem('jolkhabarSearchHistory'); // Reset if corrupted
            }
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