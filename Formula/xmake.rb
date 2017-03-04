class Xmake < Formula
  desc "Make-like build utility based on Lua"
  homepage "http://xmake.io"
  url "https://github.com/waruqi/xmake/archive/v2.1.1.tar.gz"
  sha256 "c84f8ed4c85f646a436f86f42fcc8822f3252941e8bb1cfdfe59adbded9502fc"
  head "https://github.com/waruqi/xmake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6b79ebfe9ccc0214d6a2021b89dccd9d8a12b059299486a3d7bf93848963e837" => :sierra
    sha256 "7c1fc4c357cb2cd01a150bd9c7c6ac4241931522985f223ccfe172578f2548f1" => :el_capitan
    sha256 "ad49678ff78c9471f9be71588c43085174f5caea654df7a3d67abfc5caefca69" => :yosemite
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
