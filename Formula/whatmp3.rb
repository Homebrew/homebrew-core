class Whatmp3 < Formula
  desc "Small script to create mp3 torrents out of FLACs"
  homepage "https://github.com/RecursiveForest/whatmp3"
  url "https://github.com/RecursiveForest/whatmp3/archive/v3.8.tar.gz"
  sha256 "0d8ba70a1c72835663a3fde9ba8df0ff7007268ec0a2efac76c896dea4fcf489"
  revision 2
  head "https://github.com/RecursiveForest/whatmp3.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0166d5c0eca7e9e3022baad9dea3679ede00bdfb29c1a5b875d477a38c5c74cf" => :high_sierra
    sha256 "0166d5c0eca7e9e3022baad9dea3679ede00bdfb29c1a5b875d477a38c5c74cf" => :sierra
    sha256 "0166d5c0eca7e9e3022baad9dea3679ede00bdfb29c1a5b875d477a38c5c74cf" => :el_capitan
  end

  depends_on "python"
  depends_on "flac"
  depends_on "mktorrent" => :recommended
  depends_on "lame" => :recommended
  depends_on "vorbis-tools" => :optional
  depends_on "mp3gain" => :optional
  depends_on "aacgain" => :optional
  depends_on "vorbisgain" => :optional
  depends_on "sox" => :optional

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    (testpath/"flac").mkpath
    cp test_fixtures("test.flac"), "flac"
    system "#{bin}/whatmp3", "--notorrent", "--V0", "flac"
    assert_predicate testpath/"V0/test.mp3", :exist?
  end
end
