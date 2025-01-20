!function() {
    // 640px - default sm breakpoint for tailwind
    new Glide('.glide', {
        perView: 2,
        gap: 40,
        breakpoints: {
            640: {
                perView: 1
            },
        }
    }).mount();
}();