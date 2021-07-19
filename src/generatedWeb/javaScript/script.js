//scroll to start of the page
function scrollUp() {
    window.scrollTo(0, 0);
}

//show scroll up button, if user scroll down more than 500
document.addEventListener('scroll', function() {
    const scrollUpButton = document.querySelector('.scroll-up-btn');
    
    if (window.scrollY > 500) {
        scrollUpButton.classList.add("show");
    } else {
        scrollUpButton.classList.remove("show");
    }
});