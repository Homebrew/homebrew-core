class Vlang < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  # NOTE: Keep this in sync with V compiler below when updating
  url "https://github.com/vlang/v/archive/0.2.1.tar.gz"
  sha256 "0e7d37e7ef7a5001b86811239770bd3bc13949a6489e0de87b59d9e50ea342c9"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d301fb94061abe12a53cfffc5712932d7ecc6cd9d75db14d2c9d10eac8b538b4" => :big_sur
    sha256 "32a81135659087271dd202cf02811523d68cd2242453557f66f47fb065e56e0b" => :arm64_big_sur
    sha256 "ee00e326875f3acad82d83cebbb7dc015a8f4c9fe10f3b810fb789900b327851" => :catalina
    sha256 "f16c168c9e07d11bd878a5eb32c297faf55872f617830097bbcdc2b60a7030a8" => :mojave
  end

  resource "vc" do
    # For every vlang release there is a matching commit of the V compiler in the format
    # "[v:master] {short SHA of the vlang release commit} - {vlang version number}".
    # The sources of this V compiler commit need to be used here
    url "https://github.com/vlang/vc.git",
        revision: "563c3bd5720e513326fbac728dde29454275de9d"
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
