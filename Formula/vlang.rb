class Vlang < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  # NOTE: Keep this in sync with V compiler below when updating
  url "https://github.com/vlang/v/archive/0.2.4.tar.gz"
  sha256 "8cdbc32fb928051ce7959dd943af3efee26bddc4ed3700a1cb365be73a306bf9"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c6d2d50296fdad67fb6ea868b8b530e8979db42575679fc8ffd1a1757f530147"
    sha256 cellar: :any_skip_relocation, big_sur:       "9be25862e7c69582ef1c8ee312e10e76988e5247439657f704078f56a5f6abc3"
    sha256 cellar: :any_skip_relocation, catalina:      "d4e2bde9c42995a3c348f1ede4a78fa579a22b601144cc0b8adeb009d310c1b7"
    sha256 cellar: :any_skip_relocation, mojave:        "0fe9d3b759400cee1a53c10f1a913a541d2f2f151822ff82454e953796c931cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb13270e51de665c0253e5c0f900bf88fcc24f870326ef6e1face32d7b6111fb"
  end

  resource "vc" do
    # For every vlang release there is a matching commit of the V compiler in the format
    # "[v:master] {short SHA of the vlang release commit} - {vlang version number}".
    # The sources of this V compiler commit need to be used here
    url "https://github.com/vlang/vc.git",
        revision: "fd5f57740ff6d7a8566b774318df54c2fa460f92"
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
