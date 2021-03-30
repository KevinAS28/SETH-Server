from django.conf import settings
from django.http import HttpResponse

from qr_code.qrcode.maker import make_qr_code_image
from qr_code.qrcode.utils import QRCodeOptions



def serve_qr_code_image(request) -> HttpResponse:
    """Serve an image that represents the requested QR code."""
    qr_code_options = get_qr_code_option_from_request(request)
    # Handle image access protection (we do not allow external requests for anyone).

    img = make_qr_code_image(settings.B_PLACE_NAME, qr_code_options=qr_code_options)
    return HttpResponse(content=img,
                        content_type='image/svg+xml' if qr_code_options.image_format == 'svg' else 'image/png')


def get_qr_code_option_from_request(request) -> QRCodeOptions:
    request_query = request.GET.dict()
    for key in ('text', 'token', 'cache_enabled'):
        request_query.pop(key, None)
    return QRCodeOptions(**request_query)


