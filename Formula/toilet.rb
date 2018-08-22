class Toilet < Formula
  desc "Color-based alternative to figlet (uses libcaca)"
  homepage "http://caca.zoy.org/wiki/toilet"
  url "http://caca.zoy.org/raw-attachment/wiki/toilet/toilet-0.3.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/t/toilet/toilet_0.3.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/t/toilet/toilet_0.3.orig.tar.gz"
  sha256 "89d4b530c394313cc3f3a4e07a7394fa82a6091f44df44dfcd0ebcb3300a81de"

  bottle do
    sha256 "27c9e1fe38ec012c5dd9199c8100d49c56e386c65c336a4fbcaaa25a9341cab2" => :mojave
    sha256 "dda87a313d7398dd3157ca74d752b3d364647fc56c3238fb5bd320fcc904ebd5" => :high_sierra
    sha256 "24008d251358aa73e7e597b203e360857fec5b88278e6ea6de08d4eef3865f80" => :sierra
    sha256 "93822fde3d2e69f46143dcb9d8551e7e4301c7a470ae53b3fda8ec6cb44584dd" => :el_capitan
    sha256 "7362333eea743740a9cdb064c5a74829e37b3f15645797622bb283b9cf3f3b1a" => :yosemite
    sha256 "ef2c34f742b366f84d2aeeb6d83fb94d6bd443f210e56968fb8b2b5700eab759" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libcaca"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/toilet", "--version"
  end
end
