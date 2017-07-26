class Xsv < Formula
  desc "Fast CSV toolkit written in Rust."
  homepage "https://github.com/BurntSushi/xsv"
  url "https://github.com/BurntSushi/xsv/archive/0.12.2.tar.gz"
  sha256 "484e3d4a9fec0d4c8089a77cba3e122970113e2bf0277ab6a956bf12954bbca3"
  head "https://github.com/BurntSushi/xsv.git"

  bottle do
    sha256 "e7b5bad91e0d75088045c1450970afb482b4419f777dd931775176106ed35271" => :sierra
    sha256 "e6bf617d8bc98e792dde6590194695baa6f2f6ed4ab43b90f2bf50fff1b2f6a2" => :el_capitan
    sha256 "0a3e50fe692f96af9706d2ecb8799b711c513ad9c8d8b4534b0ed0c2949e5ce3" => :yosemite
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
