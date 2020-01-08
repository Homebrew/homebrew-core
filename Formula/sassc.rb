class Sassc < Formula
  desc "Wrapper around libsass that helps to create command-line apps"
  homepage "https://github.com/sass/sassc"
  url "https://github.com/sass/sassc.git",
      :tag      => "3.6.1",
      :revision => "46748216ba0b60545e814c07846ca10c9fefc5b6"
  head "https://github.com/sass/sassc.git"

  bottle do
    cellar :any
    sha256 "b3e76afb48cf7789113e29f01389bdc5d7f13faf3e9b7f28f4bf9ef352363b0f" => :catalina
    sha256 "34e0739d4967b537d4836780cefcb47910ce8c5b8201e9f864d10c3d34801237" => :mojave
    sha256 "4461eb8cf88f6fbbfe0d15b0efd0449cc95e3e46873af0f972769594786c32ea" => :high_sierra
    sha256 "e54c8d0ddc93a8212c9c39f9e8c853a6b19ae1fc2ba3bee650785215441aa60e" => :sierra
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
