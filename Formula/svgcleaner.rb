class Svgcleaner < Formula
  desc "Cleans your SVG files by removing unnecessary data."
  homepage "https://github.com/RazrFalcon/svgcleaner"
  url "https://github.com/RazrFalcon/svgcleaner/archive/v0.8.1.tar.gz"
  sha256 "843abc42a012cd65cf680473657e2d3c0f30415c80b8e6edb86a0c5589b3db06"
  head "https://github.com/RazrFalcon/svgcleaner.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "75b973c61c68a51293d51c5def7f165de1f191dc1d8d2141e33d10d2335bb3d3" => :sierra
    sha256 "1bd89bd68e7a8e326b8c3375b44d41522102f16266ad44e1b1ec623875f07559" => :el_capitan
    sha256 "fe4032b492fae5f2dc4f509d10f9f916c67c2c30d6c3b58cfdd3c20664cd76ff" => :yosemite
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
