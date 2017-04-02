class Svgcleaner < Formula
  desc "Cleans your SVG files by removing unnecessary data."
  homepage "https://github.com/RazrFalcon/svgcleaner"
  url "https://github.com/RazrFalcon/svgcleaner/archive/v0.8.1.tar.gz"
  sha256 "843abc42a012cd65cf680473657e2d3c0f30415c80b8e6edb86a0c5589b3db06"
  head "https://github.com/RazrFalcon/svgcleaner.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a74395c183377b0ada02b3f23be828c1aa5c408523454415ceb3f8d24e606b8f" => :sierra
    sha256 "bd250af9b560c4f814e617595365ac70fc326cda0f292bb9bc22c04f03ef59f8" => :el_capitan
    sha256 "fc7ca24b2943747931b88913ed9930107577c18a50da8a0f4b8c209a725baf26" => :yosemite
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
