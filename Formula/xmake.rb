class Xmake < Formula
  desc "Make-like build utility based on Lua"
  homepage "http://xmake.io"
  url "https://github.com/tboox/xmake/archive/v2.1.4.tar.gz"
  sha256 "75be6abea3939b6ce9b306fca2a842a0bdd02ee1c5ad04b43445e2b36daa4837"
  head "https://github.com/waruqi/xmake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fbafa253cf76a3e91495289676bd58ea6a34a83e9822a0bb2a8f754df605837c" => :sierra
    sha256 "46bafc5940a7e5822a0771d95060eb0ee2dbeb0937b707103bc182623a917305" => :el_capitan
    sha256 "de17adb4711c6eb76b200639d6089cc280055a199b75d18b46e91ba78f03ba77" => :yosemite
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
