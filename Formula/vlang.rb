class Vlang < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/0.1.28.tar.gz"
  sha256 "0690764f60ceb50dd2ae3fb489c45548a30c569c7ac0e28f9f84c58a643f550f"

  bottle do
    cellar :any_skip_relocation
    sha256 "142c8a45d14e877395a822cb960556425ce4a03c82411ba81eec6234af40490a" => :catalina
    sha256 "42f524595e61d5ea1362070f6326c149042456e3eeede38973dd126043d00159" => :mojave
    sha256 "9a77a2b4471be48a694a50dc935b16e0dfca29ed6b436b74fd2f72a3b9fa0abf" => :high_sierra
  end

  resource "vc" do
    # For every vlang release there is a matching commit of the V compiler in the format
    # "[v:master] {short SHA of the vlang release commit} - {vlang version number}".
    # The sources of this V compiler commit need to be used here
    url "https://github.com/vlang/vc/archive/0e58ced.tar.gz"
    sha256 "43d6b59898ea4860d28e71c45dc5f86598e6c5d07e43550e9fffa839823c5206"
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
