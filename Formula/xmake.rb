class Xmake < Formula
  desc "A cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/archive/v2.2.6.tar.gz"
  sha256 "558a43b70d90503ba2e1a11af10d5f93772102850ee6790201fa329d174342f0"
  revision 1
  head "https://github.com/xmake-io/xmake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d3732e8eef1dfdc404cfc69942267fd1182f0cd28e9c7bf2721990ab47429196" => :mojave
    sha256 "f5c3032c525369138221bce9c0681bf394f2cce872437a534385b206baee22fd" => :high_sierra
    sha256 "2c1ad958fc1377b3af8ee2b97bd24863ca19a294eb3e821c28ad0b52fbed4bdf" => :sierra
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
