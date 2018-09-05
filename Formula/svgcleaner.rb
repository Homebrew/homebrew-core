class Svgcleaner < Formula
  desc "Cleans your SVG files by removing unnecessary data"
  homepage "https://github.com/RazrFalcon/svgcleaner"
  url "https://github.com/RazrFalcon/svgcleaner/archive/v0.9.5.tar.gz"
  sha256 "dcf8dbc8939699e2e82141cb86688b6cd09da8cae5e18232ef14085c2366290c"
  head "https://github.com/RazrFalcon/svgcleaner.git"

  bottle do
    sha256 "a21da258fc59b005061edce47a5dfc6d9ac9c0e6bd528c9047785132428e4ea9" => :mojave
    sha256 "bc7ce28fda3125d1b53d38225cf86b1a72fbfc5bdc6964014ce8a8af96cc9add" => :high_sierra
    sha256 "141b68daa2335f0ca15ed707e07b239727340942c82943d9619e0b27a072701e" => :sierra
    sha256 "4a8e60702be1d8cc7be187f8de0ead26b234d7018c567adbc4bc358b90c1aba0" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
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
