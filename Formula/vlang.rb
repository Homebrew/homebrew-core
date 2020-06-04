class Vlang < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/0.1.27.tar.gz"
  sha256 "bed0090e83ddab52615ff36f78015239a46432c16162526de87f169a42dfd602"

  bottle do
    cellar :any_skip_relocation
    sha256 "142c8a45d14e877395a822cb960556425ce4a03c82411ba81eec6234af40490a" => :catalina
    sha256 "42f524595e61d5ea1362070f6326c149042456e3eeede38973dd126043d00159" => :mojave
    sha256 "9a77a2b4471be48a694a50dc935b16e0dfca29ed6b436b74fd2f72a3b9fa0abf" => :high_sierra
  end

  resource "vc" do
    url "https://github.com/vlang/vc/archive/0884d70.tar.gz"
    sha256 "6fc0eab593ef8508cbeaadc79a86dc90e3de2ec4646236e39722930a2484eebe"
  end

  def install
    resource("vc").stage do
      system ENV.cc, "-std=gnu11", "-w", "-o", buildpath/"v", "v.c", "-lm"
    end
    system "./v", "self"
    libexec.install "cmd", "thirdparty", "v", "v.mod", "vlib"
    bin.install_symlink libexec/"v"
    pkgshare.install "examples"
  end

  test do
    cp pkgshare/"examples/hello_world.v", testpath
    system bin/"v", "-o", "test", "hello_world.v"
    assert_equal "Hello, World!", shell_output("./test").chomp
  end
end
