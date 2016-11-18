wagn.slotReady (slot) ->
  slot.find('#company-n-topic .company-list .search-result-list, #company-n-topic .topic-list .search-result-list').slick
    slidesToShow: 3
    slidesToScroll: 3
    dots: true
    variableWidth: true
    responsive: [
      {
        breakpoint: 1210
        settings:
          slidesToShow: 2
          slidesToScroll: 3
          infinite: true
          dots: true
      }
      {
        breakpoint: 800
        settings:
          slidesToShow: 1
          slidesToScroll: 2
      }
    ]
  slot.find('#banner_column1').slick
    dots: true
    autoplay: true
    autoplaySpeed: 15000
  slot.find('.homepage-company-list .pointer-list, .homepage-metric-list .pointer-list').slick
    dots: true,
    autoplay: true,
    autoplaySpeed: 15000,
    adaptiveHeight: true,
    fade: true,
    cssEase: 'linear',
  slot.find('#top-banner-wrapper .column-1 .SELF-video_image').click ->
    $('#wikirate-info-video').dialog
      modal: true
      width: 'auto'
      close: (event, ui) ->
        $('#wikirate-info-video').dialog 'destroy'
        return
    return

$(document).ready ->
  if $('.logged-in').length
    $('#top-banner-wrapper .join-us-button').text 'Invite a friend'
  return
