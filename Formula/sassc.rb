class Sassc < Formula
  desc "Wrapper around libsass that helps to create command-line apps"
  homepage "https://github.com/sass/sassc"
  url "https://github.com/sass/sassc.git",
      :tag => "3.4.7",
      :revision => "a839dfa14c81c6e772eb08cfd5ea2941315b984d"
  head "https://github.com/sass/sassc.git"

  bottle do
    cellar :any
    sha256 "f0d491a01289c08742ec97f7a3218e9fca5546afbbb993f087e3ed691a5101cc" => :high_sierra
    sha256 "26db0d043fbf54d6f1be23d91598ef3433a3ee40f61d7f9fcb4e28135643882a" => :sierra
    sha256 "878cc71e651f786e1c7e7ec102846c385a135a7109f34cdb0c647fa5717474ae" => :el_capitan
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
