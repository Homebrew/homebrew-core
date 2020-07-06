class Whatmp3 < Formula
  include Language::Python::Shebang

  desc "Small script to create mp3 torrents out of FLACs"
  homepage "https://github.com/RecursiveForest/whatmp3"
  url "https://github.com/RecursiveForest/whatmp3/archive/v3.8.tar.gz"
  sha256 "0d8ba70a1c72835663a3fde9ba8df0ff7007268ec0a2efac76c896dea4fcf489"
  license "MIT"
  revision 3
  head "https://github.com/RecursiveForest/whatmp3.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "04408ee4a9e3dc0fefe1430dd09a736d35c8a78dc2ccf600894f5f3600ad5ae5" => :catalina
    sha256 "04408ee4a9e3dc0fefe1430dd09a736d35c8a78dc2ccf600894f5f3600ad5ae5" => :mojave
    sha256 "04408ee4a9e3dc0fefe1430dd09a736d35c8a78dc2ccf600894f5f3600ad5ae5" => :high_sierra
  end

  depends_on "flac"
  depends_on "lame"
  depends_on "mktorrent"
  depends_on "python@3.8"

  def install
    system "make", "PREFIX=#{prefix}", "install"

    rewrite_shebang detected_python_shebang, bin/"whatmp3"
  end

  test do
    (testpath/"flac").mkpath
    cp test_fixtures("test.flac"), "flac"
    system "#{bin}/whatmp3", "--notorrent", "--V0", "flac"
    assert_predicate testpath/"V0/test.mp3", :exist?
  end
end
