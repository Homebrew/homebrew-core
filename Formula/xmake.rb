class Xmake < Formula
  desc "Make-like build utility based on Lua"
  homepage "http://xmake.io"
  url "https://github.com/tboox/xmake/archive/v2.1.9.tar.gz"
  sha256 "f0e1887ac0f51293ce0157a6df4eb917df24fbf0819bc5b6f50218ee0d80bc8b"
  head "https://github.com/waruqi/xmake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8341bd08dee1d816fca4004a0fa49c3b23e1da256b6e94d0c2270a45c425b261" => :high_sierra
    sha256 "0988d7d00679b9454a24adf213134f0a54c0b26f3a65c67386905523199c89b2" => :sierra
    sha256 "7a75b6b6fa23ea952354744706963d207e81a730ca13e38d3f7eb160c77d2828" => :el_capitan
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
