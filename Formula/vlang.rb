class Vlang < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://registry.npmjs.org/@angular/cli/-/cli-10.0.0.tgz"
  sha256 "daa2190d483061ad6e3bdd83c404f6ded08743525a99179b82934a3306e9d4f9"

  bottle do
    cellar :any_skip_relocation
    sha256 "b1c0fa0034e7e4d3c0ee7b57d839fbd423063074f85d5f1cb75618edbec5c143" => :catalina
    sha256 "347622daadd7af0f22ee353c79412839dfc786734a7974c53a2a92873702b75c" => :mojave
    sha256 "7a5ced2c1cfd68a1d95ce08d27ca3725575d8dff8837cb22227bef6c260a3a7d" => :high_sierra
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
