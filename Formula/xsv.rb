class Xsv < Formula
  desc "Fast CSV toolkit written in Rust"
  homepage "https://github.com/BurntSushi/xsv"
  url "https://github.com/BurntSushi/xsv/archive/0.13.0.tar.gz"
  sha256 "2b75309b764c9f2f3fdc1dd31eeea5a74498f7da21ae757b3ffd6fd537ec5345"
  head "https://github.com/BurntSushi/xsv.git"

  bottle do
    sha256 "0d374ca4691f5e5fab0ff3d05bcaee68239fc61c05cbfff93bdefc8b7a981fe7" => :high_sierra
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
