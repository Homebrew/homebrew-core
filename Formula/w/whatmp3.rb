class Whatmp3 < Formula
  include Language::Python::Shebang

  desc "Small script to create mp3 torrents out of FLACs"
  homepage "https://github.com/RecursiveForest/whatmp3"
  url "https://github.com/RecursiveForest/whatmp3/archive/refs/tags/v3.8.tar.gz"
  sha256 "0d8ba70a1c72835663a3fde9ba8df0ff7007268ec0a2efac76c896dea4fcf489"
  license "MIT"
  revision 5
  head "https://github.com/RecursiveForest/whatmp3.git", branch: "master"

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, all: "33b3b2f4177414409c8c5e06ebf4fbbbe50c6c9537c281881bcf719a9f35fecc"
  end

  depends_on "flac"
  depends_on "lame"
  depends_on "mktorrent"

  uses_from_macos "python"

  def install
    system "make", "PREFIX=#{prefix}", "install"

    rewrite_shebang detected_python_shebang(use_python_from_path: true), bin/"whatmp3"
  end

  test do
    (testpath/"flac").mkpath
    cp test_fixtures("test.flac"), "flac"
    system bin/"whatmp3", "--notorrent", "--V0", "flac"
    assert_predicate testpath/"V0/test.mp3", :exist?
  end
end
