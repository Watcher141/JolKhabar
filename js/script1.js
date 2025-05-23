function updateSecondDropdown() {
  const firstDropdown = document.getElementById("firstDropdown");
  const secondDropdown = document.getElementById("secondDropdown");
  const result = document.getElementById("result");
  
  result.classList.add("hidden");
  secondDropdown.innerHTML = '<option value="" disabled selected>Select an option</option>';

  const options = {
    fruits: ["Global"],
    vehicles: [
      "Kolkata",
      "Guwahati",
      "Bengaluru",
      "Vadodara",
      "Ahmedabad",
      "Hyderabad",
      "Pune",
      "Mumbai",
      "Gurgaon",
      "Delhi",
      "All Over India"
    ],
  };

  if (firstDropdown && options[firstDropdown.value]) {
    options[firstDropdown.value].forEach((option) => {
      const newOption = document.createElement("option");
      newOption.value = option.toLowerCase();
      newOption.text = option;
      secondDropdown.add(newOption);
    });
  }
}

async function showResult() {
  const firstDropdown = document.getElementById("firstDropdown");
  const secondDropdown = document.getElementById("secondDropdown");
  const resultDiv = document.getElementById("result");

  const firstSelection = firstDropdown.options[firstDropdown.selectedIndex]?.text;
  const secondSelection = secondDropdown.options[secondDropdown.selectedIndex]?.text;

  if (!firstSelection || !secondSelection) {
    resultDiv.innerHTML = "Please make a valid selection in both dropdowns.";
    resultDiv.classList.remove("hidden");
    return;
  }

  const places = {
    global: {
      names: ["Etsy", "Ebay"],
      urls: [
        "https://www.etsy.com/shop/JOLKHABARnDASHAKARMA",
        "https://www.ebay.com/usr/jolkhabarndashakarmka"
      ],
      types: ["etsy", "ebay"]
    },
    "all over india": {
      names: ["Amazon", "Flipkart"],
      urls: [
        "https://www.amazon.in/stores/JOLKHABAR/JOLKHABAR/page/575AAFEE-3B7F-45FB-BA9F-75F2866CD8C5",
        "https://www.flipkart.com/search?q=jolkhabar"
      ],
      types: ["amazon", "flipkart"]
    },
    kolkata: {
      names: [
        "Blinkit",
        "Big Basket",
        "Instamart",
        "Zepto",
        "Amazon",
        "Flipkart"
      ],
      urls: [
        "https://blinkit.com/brand/jolkhabar/23552",
        "https://www.bigbasket.com/ps/?q=jolkhabar&nc=as",
        "#",
        "https://www.zeptonow.com/search?query=jolkhabar",
        "https://www.amazon.in/stores/JOLKHABAR/JOLKHABAR/page/575AAFEE-3B7F-45FB-BA9F-75F2866CD8C5",
        "https://www.flipkart.com/search?q=jolkhabar"
      ],
      types: [
        "blinkit",
        "bigbasket",
        "swiggy",
        "zepto",
        "amazon",
        "flipkart"
      ]
    },
    guwahati: {
      names: ["Big Basket", "Amazon", "Flipkart"],
      urls: [
        "https://www.bigbasket.com/ps/?q=jolkhabar&nc=as",
        "https://www.amazon.in/stores/JOLKHABAR/JOLKHABAR/page/575AAFEE-3B7F-45FB-BA9F-75F2866CD8C5",
        "https://www.flipkart.com/search?q=jolkhabar"
      ],
      types: ["bigbasket", "amazon", "flipkart"]
    },
    bengaluru: {
      names: [
        "Instamart",
        "Manju's Bengali Store",
        "Kolkata Sholoana",
        "Amazon",
        "Flipkart"
      ],
      urls: [
        "#",
        "https://maps.app.goo.gl/MFzJVN1pFeDdCEUX9",
        "https://maps.app.goo.gl/uxPKGQYBkhvgvLwZ9",
        "https://www.amazon.in/stores/JOLKHABAR/JOLKHABAR/page/575AAFEE-3B7F-45FB-BA9F-75F2866CD8C5",
        "https://www.flipkart.com/search?q=jolkhabar"
      ],
      types: ["swiggy", "maps", "maps", "amazon", "flipkart"]
    },
    vadodara: {
      names: ["Bengoli Puja Store", "Amazon", "Flipkart"],
      urls: [
        "https://maps.app.goo.gl/6pQLxqw4QdwRDdi16",
        "https://www.amazon.in/stores/JOLKHABAR/JOLKHABAR/page/575AAFEE-3B7F-45FB-BA9F-75F2866CD8C5",
        "https://www.flipkart.com/search?q=jolkhabar"
      ],
      types: ["maps", "amazon", "flipkart"]
    },
    ahmedabad: {
      names: [
        "Bengal Delights",
        "Kolkata Haat",
        "Amazon",
        "Flipkart"
      ],
      urls: [
        "https://maps.app.goo.gl/E9a5kU66MFmHtjv27",
        "https://maps.app.goo.gl/XfGQ6PuhVE7rJhHJA",
        "https://www.amazon.in/stores/JOLKHABAR/JOLKHABAR/page/575AAFEE-3B7F-45FB-BA9F-75F2866CD8C5",
        "https://www.flipkart.com/search?q=jolkhabar"
      ],
      types: ["maps", "maps", "amazon", "flipkart"]
    },
    hyderabad: {
      names: [
        "Gramer Bangla",
        "Instamart",
        "Amazon",
        "Flipkart"
      ],
      urls: [
        "https://maps.app.goo.gl/Kw1hGtYyL95isht67",
        "#",
        "https://www.amazon.in/stores/JOLKHABAR/JOLKHABAR/page/575AAFEE-3B7F-45FB-BA9F-75F2866CD8C5",
        "https://www.flipkart.com/search?q=jolkhabar"
      ],
      types: ["maps", "swiggy", "amazon", "flipkart"]
    },
    pune: {
      names: [
        "Ishita Mart",
        "Instamart",
        "Amazon",
        "Flipkart"
      ],
      urls: [
        "https://maps.app.goo.gl/Pwhuyy95nPPe4hVk6",
        "#",
        "https://www.amazon.in/stores/JOLKHABAR/JOLKHABAR/page/575AAFEE-3B7F-45FB-BA9F-75F2866CD8C5",
        "https://www.flipkart.com/search?q=jolkhabar"
      ],
      types: ["maps", "swiggy", "amazon", "flipkart"]
    },
    mumbai: {
      names: [
        "Jolkhabar on eBay",
        "Bengal Delights",
        "Amazon",
        "Flipkart"
      ],
      urls: [
        "https://www.ebay.com/usr/jolkhabarndashakarmka",
        "https://maps.app.goo.gl/E9a5kU66MFmHtjv27",
        "https://www.amazon.in/stores/JOLKHABAR/JOLKHABAR/page/575AAFEE-3B7F-45FB-BA9F-75F2866CD8C5",
        "https://www.flipkart.com/search?q=jolkhabar"
      ],
      types: ["ebay", "maps", "amazon", "flipkart"]
    },
    gurgaon: {
      names: [
        "Instamart",
        "Amazon",
        "Flipkart"
      ],
      urls: [
        "#",
        "https://www.amazon.in/stores/JOLKHABAR/JOLKHABAR/page/575AAFEE-3B7F-45FB-BA9F-75F2866CD8C5",
        "https://www.flipkart.com/search?q=jolkhabar"
      ],
      types: ["swiggy", "amazon", "flipkart"]
    },
    delhi: {
      names: [
        "Instamart",
        "Amazon",
        "Flipkart"
      ],
      urls: [
        "#",
        "https://www.amazon.in/stores/JOLKHABAR/JOLKHABAR/page/575AAFEE-3B7F-45FB-BA9F-75F2866CD8C5",
        "https://www.flipkart.com/search?q=jolkhabar"
      ],
      types: ["swiggy", "amazon", "flipkart"]
    }
  };

  const selectedPlace = places[secondSelection?.toLowerCase()];

  if (selectedPlace) {
    const links = selectedPlace.names
      .map((name, index) => {
        const url = selectedPlace.urls[index];
        const type = selectedPlace.types[index];
        let icon;

        if (type === "amazon") {
          icon = `<img src="../Assets/AmazonLogo.png" alt="Amazon" class="result-icon" />`;
        } else if (type === "flipkart") {
          icon = `<img src="../Assets/FlipkartLogo.png" alt="Flipkart" class="result-icon" />`;
        } else if (type === "bigbasket") {
          icon = `<img src="../Assets/BigbasketLOgo.png" alt="Bigbasket" class="result-icon" />`;
        } else if (type === "zepto") {
          icon = `<img src="../Assets/ZeptoLogo.png" alt="Zepto" class="result-icon" />`;
        } else if (type === "blinkit") {
          icon = `<img src="../Assets/BlinkitLogo.png" alt="Blinkit" class="result-icon" />`;
        } else if (type === "swiggy") {
          icon = `<img src="../Assets/Instamart logo.avif" alt="Swiggy Instamart" class="result-icon" />`;
        } else if (type === "maps") {
          icon = `<img src="../Assets/GMAPSLOGO.png" alt="Location" class="result-icon" />`;
        } else if (type === "etsy") {
          icon = `<img src="../Assets/EtsyLogo.png" alt="Etsy" class="result-icon" />`;
        } else if (type === "ebay") {
          icon = `<img src="../Assets/ebay-icon-2048x2048-2vonydav.png" alt="Ebay" class="result-icon" />`;
        } else {
          icon = `<img src="../Assets/default.png" alt="Default" class="result-icon" />`;
        }

        return `
          <div class="result-item">
            <a href="#" class="result-link">
              <div class="platform-info">
                ${icon}
                <span>${name}</span>
              </div>
              <button class="open-button" data-url="${url}">Open</button>
            </a>
          </div>`;
      })
      .join("");

    resultDiv.innerHTML = `We are available at: <br>${links}`;
    resultDiv.classList.remove("hidden");

    // Add click handlers for the open buttons
    document.querySelectorAll('.open-button').forEach(button => {
      button.addEventListener('click', async (e) => {
        e.preventDefault();
        const url = button.dataset.url;
        const buttonText = button.textContent;
        
        // Start loading animation
        button.textContent = '';
        button.classList.add('loading');
        
        // Simulate loading (you can remove the timeout in production)
        await new Promise(resolve => setTimeout(resolve, 800));
        
        // Add vanishing animation to the entire result item
        const resultItem = button.closest('.result-item');
        resultItem.classList.add('vanish-animation');
        
        // Open the URL in a new tab
        window.open(url, '_blank');
        
        // Reset button state after animation
        setTimeout(() => {
          button.classList.remove('loading');
          button.textContent = buttonText;
          resultItem.classList.remove('vanish-animation');
        }, 500);
      });
    });
  } else {
    resultDiv.innerHTML = "Please make a valid selection in both dropdowns.";
    resultDiv.classList.remove("hidden");
  }
}