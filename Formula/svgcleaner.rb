class Svgcleaner < Formula
  desc "Cleans your SVG files by removing unnecessary data"
  homepage "https://github.com/RazrFalcon/svgcleaner"
  url "https://github.com/RazrFalcon/svgcleaner/archive/v0.9.3.tar.gz"
  sha256 "ee1d10be6545c14af7c4760222f3591757ae7847d3f0c86ac29324c44498e899"
  head "https://github.com/RazrFalcon/svgcleaner.git"

  bottle do
    sha256 "8a0791744561a977cd01273306b983cb8a21af1012839a184109ab9bfae5b7e5" => :high_sierra
    sha256 "de8fc4beb4ec29a815df2f07539696df0fa095100a6054dfa17c66a007f6f8f7" => :sierra
    sha256 "27976b0e84f222b5eef09d47423812238825a52a0eec48674d15e34e05a97a29" => :el_capitan
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
