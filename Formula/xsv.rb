class Xsv < Formula
  desc "Fast CSV toolkit written in Rust."
  homepage "https://github.com/BurntSushi/xsv"
  url "https://github.com/BurntSushi/xsv/archive/0.12.0.tar.gz"
  sha256 "72f791d4903fd56fed83295679f599025491d970d825351f5364a617c9bb5f11"
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
