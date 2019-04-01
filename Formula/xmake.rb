class Xmake < Formula
  desc "A cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/archive/v2.2.5.tar.gz"
  sha256 "1c7ce3da87c03ce9d6be20b67561421039865c8de87fc4db1f94d934c22aacf4"
  head "https://github.com/xmake-io/xmake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "252b15004aaaf198350a928094b4f88ecbbe9dc431ba2f88681719f21259c3f8" => :mojave
    sha256 "2812210a1873035a649b38ae7f9cff89da845cbe4ee4a65d028a4060c1b59d48" => :high_sierra
    sha256 "f098eda2f87fcd2d5b2d6837d93b94213f6bbf20dc655f819d84e93cdcd181a8" => :sierra
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
