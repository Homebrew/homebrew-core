class Svgcleaner < Formula
  desc "Cleans your SVG files by removing unnecessary data"
  homepage "https://github.com/RazrFalcon/svgcleaner"
  url "https://github.com/RazrFalcon/svgcleaner/archive/v0.9.2.tar.gz"
  sha256 "3b692e5cca4d82402abbe94d716091a89450c031893ba1934edd93f9b31d71cd"
  head "https://github.com/RazrFalcon/svgcleaner.git"

  bottle do
    rebuild 1
    sha256 "888718c0d72817c2744a0a3bae7901a8a9dd7bee5e98e639fcab9e3b6574fa32" => :high_sierra
    sha256 "e698442a3f8babb405b4aba64f7c8a110b17ef65138f565e8198b33da7c64fb2" => :sierra
    sha256 "69313b46c8608405a4887f002aa604361f0959b71a9df7d18a98879bb0138e12" => :el_capitan
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
