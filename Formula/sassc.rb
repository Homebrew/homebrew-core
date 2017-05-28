class Sassc < Formula
  desc "Wrapper around libsass that helps to create command-line apps"
  homepage "https://github.com/sass/sassc"
  url "https://github.com/sass/sassc.git", :tag => "3.4.5", :revision => "5909ba5b7c68ca99ef8dc1414442634fda9e4819"
  head "https://github.com/sass/sassc.git"

  bottle do
    cellar :any
    sha256 "ffb473796b1059906d32198692771f83bc216563b11a12a76591107f9303007c" => :sierra
    sha256 "bd9c09912ddc844b1b5c547c250216eec2d0c765a212dce9b5748e28d8708b58" => :el_capitan
    sha256 "4bb83df2c2b4473741b31b0cd84e1ae9bb09d75e47eb8fdb91fbce28519a89fc" => :yosemite
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
