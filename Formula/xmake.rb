class Xmake < Formula
  desc "Make-like build utility based on Lua"
  homepage "http://xmake.io"
  url "https://github.com/tboox/xmake/archive/v2.1.6.tar.gz"
  sha256 "0f1d88ad7b5c82788fdecd6e77cc7620f8bf70006ca95228bef2cf3fa7616433"
  head "https://github.com/waruqi/xmake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "eb544a2e89f167ccde77eb456fe0a6af0d11364a0e6f5543a366fab3f92335b6" => :sierra
    sha256 "6afca5097e3718b9c8efa55c54dec7241a0be7b45405ca668db432959038a248" => :el_capitan
    sha256 "e980cd27838bec8085559305af416cf9f55f059c8e3e74d452d4a89d41523d08" => :yosemite
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
