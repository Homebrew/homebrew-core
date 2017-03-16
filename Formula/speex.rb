class Speex < Formula
  desc "Audio codec designed for speech"
  homepage "https://speex.org"
  url "http://downloads.us.xiph.org/releases/speex/speex-1.2.0.tar.gz"
  sha256 "eaae8af0ac742dc7d542c9439ac72f1f385ce838392dc849cae4536af9210094"

  bottle do
    cellar :any
    sha256 "5aa61761fb5426de78297fdc83579515dda1a880f47c925cb3405b7175079b92" => :sierra
    sha256 "056781a4d7c5fe9a05f30160c059352bda0a4f8a759820df7dde7233aa08cba5" => :el_capitan
    sha256 "a0b3c91782b8242508adac3ebc0cd86688e75b043ea0d84f4ef7ac9940f8a21b" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libogg" => :recommended

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
