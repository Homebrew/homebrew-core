class Sassc < Formula
  desc "Wrapper around libsass that helps to create command-line apps"
  homepage "https://github.com/sass/sassc"
  url "https://github.com/sass/sassc.git", :tag => "3.4.2", :revision => "19d97ea089c558a07e61566142f59f88b7a1cc99"
  head "https://github.com/sass/sassc.git"

  bottle do
    cellar :any
    sha256 "f4e0ea6eb7352b39e05a740984d04012a868404712e8d18ae14cd760ff7004e2" => :sierra
    sha256 "32d389cdf8d9b4062186c5f3f6cddf5dbc8dd7f1c8156f721340dd8a8a658d20" => :el_capitan
    sha256 "42e8c985787f26ec40c356ae8597fabad705108d8a0752ba4fbf4a519277d219" => :yosemite
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
    (testpath/"input.scss").write <<-EOS.undent
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
