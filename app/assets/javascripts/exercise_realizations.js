// Make elements with string selector the same height
function makeElementsSameHeight(selector){
    // Get title box with max height
    var maxHeight = Math.max.apply(null, $(selector).map(function ()
    {return $(this).innerHeight();}).get());
    // Set all heights accordingly
    $(selector).css('min-height', maxHeight);
}