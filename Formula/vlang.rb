class Vlang < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  # NOTE: Keep this in sync with V compiler below when updating
  url "https://github.com/vlang/v/archive/0.1.30.tar.gz"
  sha256 "5f2be9765e7ec6fb79286b973d319359377dcf78a0470652048a261d77a6ae14"
  license "MIT"

  livecheck do
    url "https://raw.githubusercontent.com/vlang/v/master/CHANGELOG.md"
    regex(/## v?\s?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "4e3d0af15fbd9cfd98157e468e6479f04666c7ffda7bb092c356228867579a03" => :big_sur
    sha256 "c9f90f6472af2dc0367fc2b36176730cc8ee37d022da550d532044dbf77d23db" => :catalina
    sha256 "e6b819f3d96b3c41590a0248483067e88664efffff55a95d18475e2fa63f83ab" => :mojave
  end

  resource "vc" do
    # For every vlang release there is a matching commit of the V compiler in the format
    # "[v:master] {short SHA of the vlang release commit} - {vlang version number}".
    # The sources of this V compiler commit need to be used here
    url "https://github.com/vlang/vc.git",
      revision: "e8da48b5e44c3671cf5fc649cae5c38983b1ff52"
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
