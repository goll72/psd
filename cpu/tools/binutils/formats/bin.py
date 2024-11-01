from . import FormatHandler

class BinFormatHandler(FormatHandler):
    def serialize(self, data: list[int]) -> bytes:
        return bytes(data)
        
    def deserialize(self, data: bytes) -> list[int]:
        return list(data)
