class Xmake < Formula
  desc "A cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/archive/v2.2.6.tar.gz"
  sha256 "558a43b70d90503ba2e1a11af10d5f93772102850ee6790201fa329d174342f0"
  revision 1
  head "https://github.com/xmake-io/xmake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a164c57e3f9412b9112df95b9c762044ecb3c9faa273c7b309f1c235b6c19cd4" => :mojave
    sha256 "296971995bfe162541418acb93d843da0a9af6842c89ca8ba310e0d82c29fce5" => :high_sierra
    sha256 "7ee500fe217bc9ca6e8df78ab5ddf9100de3a0ff5bc80ea91623c2c1a3839798" => :sierra
  end

  def install
    system "./install", "output"
    pkgshare.install Dir["xmake/*"]
    bin.install "output/share/xmake/xmake"
    bin.env_script_all_files(libexec, :XMAKE_PROGRAM_DIR => pkgshare)
  end

  test do
    system bin/"xmake", "create", "-P", testpath
    system bin/"xmake"
    assert_equal "hello world!", shell_output("#{bin}/xmake run").chomp
  end
end
