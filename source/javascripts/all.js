// $('.masonry').addClass('is-loading');

$( document ).ready(function() {

  $('.masonry.is-loading').each(function() {
    var $infoLoading = $('.info-loading');
    var $infoLoadingText = $('.info-loading-text');
    var $masonry = $(this);
    var $imageItems = $masonry.find('.item-image');
    var imagesCounter = $imageItems.length;
    var imagesCount = imagesCounter;

    $infoLoadingText.text('0%');
    $infoLoading.fadeIn(400);

    $imageItems.each(function() {
      var $image = $(this).find('img:first');

      $image.one('load', function() {
        imagesCounter--;
        percent = Math.floor(100 - (imagesCounter * 100 / imagesCount));
        $infoLoadingText.text(percent + '%');
        if (imagesCounter < 1) {
          $infoLoading.fadeOut(400, function() {
            $masonry.removeClass('is-loading');
          });
        }
      }).each(function() {
        if (this.complete) { $(this).trigger('load'); }
      });
    });
  });

  $('.item-image a').swipebox();
});
