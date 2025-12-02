class Whatmp3 < Formula
  include Language::Python::Shebang

  desc "Small script to create mp3 torrents out of FLACs"
  homepage "https://github.com/RecursiveForest/whatmp3"
  url "https://github.com/RecursiveForest/whatmp3/archive/refs/tags/v3.9.tar.gz"
  sha256 "4ee468ff5a380c3ee4dbfadfd25ac76797ac63203b21588a997f339e124559f4"
  license "MIT"
  head "https://github.com/RecursiveForest/whatmp3.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d2a7f02319c285fdb7f1ecd703b2ac07721c727bb2611cef1767d8c36115dfa2"
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
    assert_path_exists testpath/"V0/test.mp3"
  end
end
