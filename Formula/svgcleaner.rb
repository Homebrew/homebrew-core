class Svgcleaner < Formula
  desc "Cleans your SVG files by removing unnecessary data."
  homepage "https://github.com/RazrFalcon/svgcleaner"
  url "https://github.com/RazrFalcon/svgcleaner/archive/v0.7.0.tar.gz"
  sha256 "c0a2cc56c77486700c7229538d30e77b55fc9713e5f2e8660fea86053a7789c9"
  head "https://github.com/RazrFalcon/svgcleaner.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "33034cfaeb2db6c78d3132ecb264f3689602f33779bd07369f4c644998a43103" => :sierra
    sha256 "16529a3278175c94ea4921483c6813f22866949bddff5b87dbd605c85ca70187" => :el_capitan
    sha256 "25af4f2b942cfbdab1ab204fb8ec487544e4da2d9b669e5bd8fe8df71693d4ef" => :yosemite
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
