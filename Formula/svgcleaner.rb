class Svgcleaner < Formula
  desc "Cleans your SVG files by removing unnecessary data."
  homepage "https://github.com/RazrFalcon/svgcleaner"
  url "https://github.com/RazrFalcon/svgcleaner/archive/v0.9.1.tar.gz"
  sha256 "c2a3fe8a70d58cd596366c8ec5aab5e703b97488daa4da4c2f03e723c0ae5d27"
  head "https://github.com/RazrFalcon/svgcleaner.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1d35f069810274cd1d8d60880b90e4a425d538b09c1f884a959fb8ae8887e772" => :sierra
    sha256 "8121cd9a7902b70a6bbb6cef5b2ba1b57d98050c6807f435430765b15b65ce66" => :el_capitan
    sha256 "c2a4b2d96496fb98f94250d1964038a48e80e67b22e460eb6c2da5d2b01854bf" => :yosemite
  end

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release"
    bin.install "target/release/svgcleaner"
  end

  test do
    (testpath/"in.svg").write <<-EOS.undent
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
