class Tin < Formula
  desc "Threaded, NNTP-, and spool-based UseNet newsreader"
  homepage "http://www.tin.org"
  url "http://ftp.cuhk.edu.hk/pub/packages/news/tin/v2.4/tin-2.4.0.tar.gz"
  sha256 "26ee20980c88308f225c0bae55b6db12365ced3398dbea0621992dff0e74cbb6"

  bottle do
    sha256 "299d98d164fd4a1aba5e66ff4f1bc75d415acfad49555183a793ec9e44323ecf" => :sierra
    sha256 "24b40c6319c0673d13ad30121de18c7797a97ef9b4ad14b92f7aa56fb07a1ae4" => :el_capitan
    sha256 "1444c2fa1a3f63f4f8f8330b69d6c255c70c4732d13673a4beab2d621d753d3e" => :yosemite
    sha256 "11505b2e7b9953370a54fab8dc3460e28d3aabc1e02d2d713d514e4a78eb68d7" => :mavericks
    sha256 "231470502b1e124011bd79c44d84740d068ccc32aad86a5599e7006755e7a200" => :mountain_lion
  end

  conflicts_with "mutt", :because => "both install mmdf.5 and mbox.5 man pages"

  def install
    ENV.enable_warnings
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "build"
    system "make", "install"
  end

  test do
    system "#{bin}/tin", "-H"
  end
end
