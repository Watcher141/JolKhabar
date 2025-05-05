// Create the back to top button element
function createBackToTopButton() {
  // Create button element
  const backToTopButton = document.createElement('a');
  backToTopButton.href = '#';
  backToTopButton.className = 'back-to-top';
  backToTopButton.id = 'backToTopButton';
  
  // Create SVG icon
  backToTopButton.innerHTML = `
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
      <path d="M12 4l-8 8h6v8h4v-8h6z" />
    </svg>
  `;
  
  // Add to the document
  document.body.appendChild(backToTopButton);
  
  // Add scroll event to show/hide button
  window.addEventListener('scroll', () => {
    if (window.scrollY > 300) {
      backToTopButton.classList.add('show');
    } else {
      backToTopButton.classList.remove('show');
    }
  });
  
  // Add click event to scroll to top
  backToTopButton.addEventListener('click', (e) => {
    e.preventDefault();
    window.scrollTo({ top: 0, behavior: 'smooth' });
  });
}

// Add button when DOM is loaded
document.addEventListener('DOMContentLoaded', createBackToTopButton);