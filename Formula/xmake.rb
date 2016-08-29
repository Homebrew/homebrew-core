class Xmake < Formula
  desc "Make-like build utility based on Lua"
  homepage "http://xmake.io"
  url "https://github.com/waruqi/xmake/archive/v2.0.4.tar.gz"
  sha256 "50e59bcc37f5f4c0853a9b27a88e3830561bc056c74d6a1f81b92937f9d80f89"
  head "https://github.com/waruqi/xmake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ec118cea9544e2a17906c28a71f37511e67632087d63b8bada1c3d8a21c191cd" => :el_capitan
    sha256 "9120c6274000e37374bd27c757c000af4d81962c9b31a9ca3f213282f3462009" => :yosemite
    sha256 "62a06cd76179965b01ab919661c8f8bca129b268032abd1d3feb5e866f5816c2" => :mavericks
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
