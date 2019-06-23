class Sassc < Formula
  desc "Wrapper around libsass that helps to create command-line apps"
  homepage "https://github.com/sass/sassc"
  url "https://github.com/sass/sassc.git",
      :tag      => "3.6.1",
      :revision => "46748216ba0b60545e814c07846ca10c9fefc5b6"
  head "https://github.com/sass/sassc.git"

  bottle do
    cellar :any
    sha256 "f28ea6ff8afd720d1a06c3d73ae87fa4381f24c3bd23ed288a2d4631bb2c993c" => :mojave
    sha256 "3940b89a275abb05f4dc41d7cb5c2676726b2e9aaf696cc18ea761419d441e0d" => :high_sierra
    sha256 "82e99be7bcdb01ab32c731c70a134af662dbe54de1ca183effd0face986ba13c" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libsass"

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--prefix=#{prefix}", "--disable-silent-rules",
                          "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    (testpath/"input.scss").write <<~EOS
      div {
        img {
          border: 0px;
        }
      }
    EOS

    assert_equal "div img{border:0px}",
    shell_output("#{bin}/sassc --style compressed input.scss").strip
  end
end
