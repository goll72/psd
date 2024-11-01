from abc import ABC, abstractmethod

class FormatHandler(ABC):
    @abstractmethod
    def serialize(self, data: list[int]) -> bytes:
        pass

    @abstractmethod
    def deserialize(self, data: bytes) -> list[int]:
        pass
