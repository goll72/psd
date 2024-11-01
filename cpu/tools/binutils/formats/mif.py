import re

from . import FormatHandler

class MifFormatHandler(FormatHandler):
    def __init__(self):
        self.comments_re = re.compile(r"--[^\n]*\n|%[^%]*%")
        self.attrs_content_re = re.compile(r"(.*)CONTENT\s*BEGIN(.*)END", re.I | re.S)

        self.attr_re = re.compile(r"(\w+)\s*=\s*(\w+)", re.I | re.S)
        self.content_re = re.compile(r"\s*\[([0-9a-f]+)(?:\.\.([0-9a-f]+))?\]\s*:\s*([0-9a-f]+)", re.I)
        
    def serialize(self, data: list[int]) -> bytes:
        output = []

        output.append("DEPTH = 256;")
        output.append("WIDTH = 8;")
        output.append("ADDRESS_RADIX = HEX;")
        output.append("DATA_RADIX = HEX;")

        output.append("CONTENT BEGIN");

        index = 0

        while index < len(data):
            for next in range(index + 1, len(data) + 1):
                if next == len(data) or data[next] != data[index]:
                    break

            if index == next - 1:
                output.append(f"[{index:x}]: {data[index]:x}")
            else:
                output.append(f"[{index:x}..{next - 1:x}]: {data[index]:x}")

            index = next
        
        output.append("END;\n")

        return bytes("\n".join(output), "utf-8")

    def deserialize(self, data: bytes) -> list[int]:
        data = data.decode("utf-8")
        re.sub(self.comments_re, "", data)
        
        matches = re.search(self.attrs_content_re, data)

        attrs, content = matches.groups()

        results = re.findall(self.attr_re, attrs)
        results = dict([ (x[0].lower(), x[1]) for x in results ])

        address_radix = results["address_radix"].lower()
        data_radix = results["data_radix"].lower()

        depth = int(results["depth"])

        code = [ 0 ] * depth

        bases = {
            "hex": 16,
            "dec": 10,
            "oct": 8,
            "bin": 2 
        }

        max = 0
        
        for line in content.split("\n"):
            matches = re.search(self.content_re, line)

            if matches is None:
                continue

            start, end, value = matches.groups()

            start = int(start, base=bases[address_radix])
            value = int(value, base=bases[data_radix])

            if end is None:
                if start > max:
                    max = start
                    
                code[start] = value
            else:
                if end > max:
                    max = end

                end = int(end, base=bases[address_radix])

                for i in range(start, end + 1):
                    code[i] = value

        code = code[:max]

        return code
