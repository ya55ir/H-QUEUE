module VenuesHelper
  def venue_qr_code_tag(venue)
    RQRCode::QRCode.new(venue_url(venue)).as_svg(
      module_size: 6,
      standalone: true,
      use_path: true
    ).html_safe
  end
end
