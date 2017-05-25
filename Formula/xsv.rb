class Xsv < Formula
  desc "Fast CSV toolkit written in Rust."
  homepage "https://github.com/BurntSushi/xsv"
  url "https://github.com/BurntSushi/xsv/archive/0.12.1.tar.gz"
  sha256 "40e7463f913ce49593b575100fd51f85f2f5deabf918849f2a93c39e057d74a9"
  head "https://github.com/BurntSushi/xsv.git"

  bottle do
    sha256 "c2717baa8aa5b65215110c1c86e15ed753b6027a824c85394feff8a581c7e03f" => :sierra
    sha256 "19338062a97e4ef3f6f0df0e4f4b7949827919290f498ec3be306cb804360ae2" => :el_capitan
    sha256 "a135ff68e70b2df982e783be0178d438cc79203b5959d11d90a613703b9e9897" => :yosemite
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
