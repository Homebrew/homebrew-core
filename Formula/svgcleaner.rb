class Svgcleaner < Formula
  desc "Cleans your SVG files by removing unnecessary data"
  homepage "https://github.com/RazrFalcon/svgcleaner"
  url "https://github.com/RazrFalcon/svgcleaner/archive/v0.9.5.tar.gz"
  sha256 "dcf8dbc8939699e2e82141cb86688b6cd09da8cae5e18232ef14085c2366290c"
  head "https://github.com/RazrFalcon/svgcleaner.git"

  bottle do
    sha256 "81305592400f38413a55a9440da21dedb2e22b0ded7b8373f9e0d5d395e8f609" => :high_sierra
    sha256 "0506b4160a81a8569be2509b5bea3849ee49f69c2c31bc377c6aeeafc7d438d9" => :sierra
    sha256 "8691e45c864d3ae5a7b313561be03686952b0b1b2b4527f7dfd68f101e3478ac" => :el_capitan
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
