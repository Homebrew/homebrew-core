class Svgcleaner < Formula
  desc "Cleans your SVG files by removing unnecessary data"
  homepage "https://github.com/RazrFalcon/svgcleaner"
  url "https://github.com/RazrFalcon/svgcleaner/archive/v0.9.3.tar.gz"
  sha256 "ee1d10be6545c14af7c4760222f3591757ae7847d3f0c86ac29324c44498e899"
  head "https://github.com/RazrFalcon/svgcleaner.git"

  bottle do
    sha256 "23ac82e9171416bd33c1b2c2da3300ca89e40aa11f9917bf02ae67b2174a7374" => :high_sierra
    sha256 "e70e90a59e68bb5a9ce55d4f143f07d3eba5ae2bee85f0a989041a63a500da64" => :sierra
    sha256 "bd74987b04d014c1f5ea4c7aece71f0ab5f00d7a9f4237f8dd5d2823169d95da" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release"
    bin.install "target/release/svgcleaner"
  end

  test do
    (testpath/"in.svg").write <<~EOS
      <?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <svg
         xmlns="http://www.w3.org/2000/svg"
         version="1.1"
         width="150"
         height="150">
        <rect
           width="90"
           height="90"
           x="30"
           y="30"
           style="fill:#0000ff;fill-opacity:0.75;stroke:#000000"/>
      </svg>
    EOS
    system "#{bin}/svgcleaner", "in.svg", "out.svg"
  end
end
