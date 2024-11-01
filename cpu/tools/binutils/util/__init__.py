from formats.bin import BinFormatHandler
from formats.mif import MifFormatHandler

FORMATS = {
    "bin": BinFormatHandler(),
    "mif": MifFormatHandler()
}
