class Xmake < Formula
  desc "Make-like build utility based on Lua"
  homepage "http://xmake.io"
  url "https://github.com/waruqi/xmake/archive/v2.0.4.tar.gz"
  sha256 "50e59bcc37f5f4c0853a9b27a88e3830561bc056c74d6a1f81b92937f9d80f89"
  head "https://github.com/waruqi/xmake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "605946f48452fe398244f1152176514fbf1d1cf9f79f0813bc09d9f225fcaf12" => :el_capitan
    sha256 "29ab7b8d0385baafc45613f1e22ddcdcc29fab44f2d88da98c866d7de4b2cb5f" => :yosemite
    sha256 "193ae7aa90ac5b6c0f0c88fef7e39f647c72b6dc990a6ab1707c1e3e50f2de63" => :mavericks
  end

  def install
    system "./install", "output"
    pkgshare.install Dir["xmake/*"]
    bin.install "output/share/xmake/xmake"
    bin.env_script_all_files(libexec, :XMAKE_PROGRAM_DIR => pkgshare)
  end

  test do
    system bin/"xmake", "create", "-P", testpath
    assert_match "build ok!", pipe_output(bin/"xmake")
  end
end
