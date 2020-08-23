class TreCommand < Formula
  desc "Tree command, improved"
  homepage "https://github.com/dduan/tre"
  url "https://github.com/dduan/tre/archive/v0.3.2.tar.gz"
  sha256 "7773cd958c9f7cf2747a7526d879de6034ba0287e161a698ec61ba7bd2ed91bb"
  license "MIT"
  head "https://github.com/dduan/tre.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "850e60da6af3a6a385a6f176b89f48808d3000682cc639203dc722aa8dddbab0" => :catalina
    sha256 "2c3ac22146a844ede3c8f2689e6ec00ff8dcddf4432fee2783d8cccfdf1d9e8f" => :mojave
    sha256 "de1035a4023926ae8a8be54d00d3749c079a2954a8de25594a00584da71192d9" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "manual/tre.1"
  end

  test do
    (testpath/"foo.txt").write("")
    assert_match("── foo.txt", shell_output("#{bin}/tre"))
  end
end
