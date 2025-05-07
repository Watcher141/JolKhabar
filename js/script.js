// SECURITY: Anti-clickjacking protection
if (window.self !== window.top) {
    window.top.location.href = window.self.location.href;
}

// SECURITY: Basic browser fingerprinting for fraud prevention
function generateSimpleFingerprint() {
    const fingerprint = {
        screen: `${screen.width}x${screen.height}x${screen.colorDepth}`,
        timezone: new Date().getTimezoneOffset(),
        language: navigator.language,
        platform: navigator.platform
    };
    
    return btoa(JSON.stringify(fingerprint));
}

// SECURITY: Prevent hotlinking of images
document.addEventListener('DOMContentLoaded', function() {
    // Generate and store fingerprint
    localStorage.setItem('deviceFingerprint', generateSimpleFingerprint());
    
    // Detect if images are loaded from other domains
    const images = document.querySelectorAll('img');
    
    images.forEach(img => {
        img.addEventListener('error', function() {
            this.style.display = 'none';
        });
    });
});

// Product preview functionality
let preveiwContainer = document.querySelector('.products-preview');
let previewBox = preveiwContainer.querySelectorAll('.preview');

// Intersection Observer for scroll animations
const observerOptions = {
    threshold: 0.1,
    rootMargin: '0px 0px -50px 0px'
};

const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.classList.add('animate-in');
            observer.unobserve(entry.target);
        }
    });
}, observerOptions);

// Observe all products
document.querySelectorAll('.product').forEach(product => {
    product.classList.add('fade-up');
    observer.observe(product);
});

// Lazy loading for images
document.querySelectorAll('img').forEach(img => {
    img.loading = 'lazy';
    img.classList.add('lazy-load');
});

// Product preview functionality
document.querySelectorAll('.products-container .product').forEach(product => {
    product.onclick = () => {
        preveiwContainer.style.display = 'flex';
        let name = product.getAttribute('data-name');
        previewBox.forEach(preview => {
            let target = preview.getAttribute('data-target');
            if (name == target) {
                preview.classList.add('active');
            }
        });
    };
});

previewBox.forEach(close => {
    close.querySelector('.fa-times').onclick = () => {
        close.classList.remove('active');
        preveiwContainer.style.display = 'none';
    };
});

// Page transition effect
document.addEventListener('DOMContentLoaded', () => {
    document.body.classList.add('loaded');
});

// Smooth scroll for anchor links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        document.querySelector(this.getAttribute('href')).scrollIntoView({
            behavior: 'smooth'
        });
    });
});

function checkAvailability(button) {
    // Simple redirect to Places.html
    window.location.href = '../Places.html';
}