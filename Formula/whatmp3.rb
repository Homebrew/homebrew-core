class Whatmp3 < Formula
  desc "Small script to create mp3 torrents out of FLACs"
  homepage "https://github.com/RecursiveForest/whatmp3"
  url "https://github.com/RecursiveForest/whatmp3/archive/v3.8.tar.gz"
  sha256 "0d8ba70a1c72835663a3fde9ba8df0ff7007268ec0a2efac76c896dea4fcf489"
  revision 1
  head "https://github.com/RecursiveForest/whatmp3.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a7b12026d65a3bb2a5e1b8ca2c834179ec24a7f082d5a67a5381bd21f3b595e3" => :high_sierra
    sha256 "4b9cae8fe803bbb26ee73e1724dba6e679d384fba7df680a42363b8f45a848d8" => :sierra
    sha256 "d50a1cb3c8406226f5b06750652ec7928243b9367723fe4def66332f412c719b" => :el_capitan
    sha256 "d50a1cb3c8406226f5b06750652ec7928243b9367723fe4def66332f412c719b" => :yosemite
  end

  depends_on "python3"
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
