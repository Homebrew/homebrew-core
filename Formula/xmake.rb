class Xmake < Formula
  desc "Make-like build utility based on Lua"
  homepage "http://xmake.io"
  url "https://github.com/tboox/xmake/archive/v2.1.4.tar.gz"
  sha256 "75be6abea3939b6ce9b306fca2a842a0bdd02ee1c5ad04b43445e2b36daa4837"
  head "https://github.com/waruqi/xmake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "916ebbf59ecaece1bc27462fd31ec1633005de201adb70d986e9308de0a40013" => :sierra
    sha256 "79f78a202c29fa947d75c277a130130375fb853d345224fb798d0731fe6d2418" => :el_capitan
    sha256 "c9d5e18377434432f957eeaae6a5a14e8fce527ba14a1b6ffc798f21cfda511e" => :yosemite
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
