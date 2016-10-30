class Whatmp3 < Formula
  desc "Small script to create mp3 torrents out of FLACs"
  homepage "https://github.com/RecursiveForest/whatmp3"
  url "https://github.com/RecursiveForest/whatmp3/archive/v3.7.tar.gz"
  sha256 "a8b688e2e5873e3bf527fc44e8f3966227b432cf59593062dd58493df65de3b0"
  head "https://github.com/RecursiveForest/whatmp3.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d39eb890cf6cd27fca7e552ce2bf046f7b708ac50aadcade5517e0ad413e89c6" => :sierra
    sha256 "86c84dbc0ce4a709418896ba50776dfe0465ee0f03110736988eb9babfff3e04" => :el_capitan
    sha256 "3fccae200f82415da7e94c69be6fc6262e078d90526e62e60d602847bfdfd0df" => :yosemite
    sha256 "3fccae200f82415da7e94c69be6fc6262e078d90526e62e60d602847bfdfd0df" => :mavericks
  end

  depends_on :python3
  depends_on "flac"
  depends_on "mktorrent" => :recommended
  depends_on "lame" => :recommended
  depends_on "vorbis-tools" => :optional
  depends_on "mp3gain" => :optional
  depends_on "aacgain" => :optional
  depends_on "vorbisgain" => :optional
  depends_on "sox" => :optional

  def install
    inreplace "whatmp3.py", "#!/usr/bin/env python", "#!/usr/bin/env python3"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    # Create dummy FLAC
    (testpath/"flac/file.flac").write "fLaC\x00\x00\x00\"\x04\x80\x04\x80\x00\x00\f\x00\x00\f\x01\xF4\x00\xF0\x00\x00\x00\x01\xF3\x8B\xE3\xDBM\x93\xE40\\~$\xBE\x94\xEF\x01\x9A\x84\x00\x00( \x00\x00\x00reference libFLAC 1.2.1 20070917\x00\x00\x00\x00\xFF\xF8d\b\x00\x00\xE3\x03\x01\xFD\xEC\x10"
    system "#{bin}/whatmp3", "--notorrent", "--V0", "flac"
    assert (testpath/"V0/file.mp3").exist?
  end
end
