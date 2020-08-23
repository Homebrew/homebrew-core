class Vlang < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  # Note: Keep this in sync with V compiler below when updating
  url "https://github.com/vlang/v/archive/0.1.29.tar.gz"
  sha256 "5111d04663d8454c9e8bcbd7e3544dcbd6abc54eb5034e31649417af6e8418a6"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "584ea22b4d50d0da4f08cae22b8f59f4a9fe4b789a2c070d22d0b7dc36be864a" => :catalina
    sha256 "a67724f8d35b90f3ebc4f385bd2eb6658e340a1d38a42f7328fd545324e35935" => :mojave
    sha256 "33a9a5f5ece4ab6088e08b5d6e4d31c34a041a5b2cc006eb5270b332c5d6ee25" => :high_sierra
  end

  resource "vc" do
    # For every vlang release there is a matching commit of the V compiler in the format
    # "[v:master] {short SHA of the vlang release commit} - {vlang version number}".
    # The sources of this V compiler commit need to be used here
    url "https://github.com/vlang/vc.git",
      revision: "b01d0fcda4b55861baa4be82e307cca4834b1641"
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
