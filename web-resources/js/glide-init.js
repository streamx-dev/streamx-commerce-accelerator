!function() {
    // 1024px - default md breakpoint for tailwind
    new Glide('.glide', {
        perView: 2,
        gap: 40,
        breakpoints: {
            1023: {
                perView: 1
            },
        }
    }).mount();
}();