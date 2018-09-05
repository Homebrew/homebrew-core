class Sassc < Formula
  desc "Wrapper around libsass that helps to create command-line apps"
  homepage "https://github.com/sass/sassc"
  url "https://github.com/sass/sassc.git",
      :tag => "3.5.0",
      :revision => "aa6d5c635ea8faf44d542a23aaf85d27e5777d48"
  head "https://github.com/sass/sassc.git"

  bottle do
    cellar :any
    sha256 "0776912423914ce74e8451f0b66004cae6f2e00a8c40e4a35f77fdbe0d036b72" => :mojave
    sha256 "efda15371cdf37716f508cbbbc7512bd4db103cbdd25a0a5b27ae74e6f5a4705" => :high_sierra
    sha256 "8160ead69c6f3e7665cb474e719cc244412c37335013e4d98bf10bfdfcff6a32" => :sierra
    sha256 "32edbfd6543029224ea742a23f0bac7f675a9aa8e7a0511cee09561518591854" => :el_capitan
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
