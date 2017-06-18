class Svgcleaner < Formula
  desc "Cleans your SVG files by removing unnecessary data."
  homepage "https://github.com/RazrFalcon/svgcleaner"
  url "https://github.com/RazrFalcon/svgcleaner/archive/v0.9.1.tar.gz"
  sha256 "c2a3fe8a70d58cd596366c8ec5aab5e703b97488daa4da4c2f03e723c0ae5d27"
  head "https://github.com/RazrFalcon/svgcleaner.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "15ddb0a036c475fb50aea4d0e3e1bbc9f2cf72e197aafe4ed95e213093af2e78" => :sierra
    sha256 "f54c2e895dd670200768356d8bd8208e3b84a5927e7d1c20fef06dc5e7a5aede" => :el_capitan
    sha256 "daad56eafd53428772d394dc84694de182f18b6720e2c74f7f17567acaabb877" => :yosemite
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
