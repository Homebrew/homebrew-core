class Vlang < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  # NOTE: Keep this in sync with V compiler below when updating
  url "https://github.com/vlang/v/archive/0.2.2.tar.gz"
  sha256 "9152eec96d2eeb575782cf138cb837f315e48c173878857441d98ba679e3a9bf"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "9be25862e7c69582ef1c8ee312e10e76988e5247439657f704078f56a5f6abc3" => :big_sur
    sha256 "c6d2d50296fdad67fb6ea868b8b530e8979db42575679fc8ffd1a1757f530147" => :arm64_big_sur
    sha256 "d4e2bde9c42995a3c348f1ede4a78fa579a22b601144cc0b8adeb009d310c1b7" => :catalina
    sha256 "0fe9d3b759400cee1a53c10f1a913a541d2f2f151822ff82454e953796c931cf" => :mojave
  end

  resource "vc" do
    # For every vlang release there is a matching commit of the V compiler in the format
    # "[v:master] {short SHA of the vlang release commit} - {vlang version number}".
    # The sources of this V compiler commit need to be used here
    url "https://github.com/vlang/vc.git",
        revision: "31dd14b7927f154682437be1f2fbeed36c59ea2b"
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
