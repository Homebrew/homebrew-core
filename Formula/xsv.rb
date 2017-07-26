class Xsv < Formula
  desc "Fast CSV toolkit written in Rust."
  homepage "https://github.com/BurntSushi/xsv"
  url "https://github.com/BurntSushi/xsv/archive/0.12.2.tar.gz"
  sha256 "484e3d4a9fec0d4c8089a77cba3e122970113e2bf0277ab6a956bf12954bbca3"
  head "https://github.com/BurntSushi/xsv.git"

  bottle do
    sha256 "85bd78adf255149d4d6a646462572b72f2a3c154173f34f4b1bfe9f390b77f68" => :sierra
    sha256 "27100a2dc22c8eb3b885003dfd8b761df21b3ac76f3d285127c381cdd1cdba66" => :el_capitan
    sha256 "b5171016edd9758a393163ff5393eb77cd0c4936f60badbff77adfd0e8373671" => :yosemite
  end

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release"

    bin.install "target/release/xsv"
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    system "#{bin}/xsv", "stats", "test.csv"
  end
end
