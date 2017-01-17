class Xmake < Formula
  desc "Make-like build utility based on Lua"
  homepage "http://xmake.io"
  url "https://github.com/waruqi/xmake/archive/v2.0.5.tar.gz"
  sha256 "e3d104aaabac7e0c01b325e8bb72d2f22c4ec94158d8afb399f8c98a418b0456"
  head "https://github.com/waruqi/xmake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "63a0839dc2dd8a1ed8a3716e6cadf8785b689d55ee9c6b11bc9a1dec9a370c14" => :sierra
    sha256 "8480352ec27324ca849f6b335fed7e8ba5cc7256ee1b1885d757164b0a647441" => :el_capitan
    sha256 "864d49d0af782b005a7cde7791fe009dda375fa6fd085c24b4c86771f358cd23" => :yosemite
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
