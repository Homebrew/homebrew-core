class Sassc < Formula
  desc "Wrapper around libsass that helps to create command-line apps"
  homepage "https://github.com/sass/sassc"
  url "https://github.com/sass/sassc.git",
      :tag => "3.4.8",
      :revision => "aa6d5c635ea8faf44d542a23aaf85d27e5777d48"
  head "https://github.com/sass/sassc.git"

  bottle do
    cellar :any
    sha256 "f48aaee9afc666a7ac0ce4b341b7e15b4e4d9404a77500e73da3cdfd73d4eaa8" => :high_sierra
    sha256 "bcc4826570ea3b06ce0abbe121c34dceb4bbe63725813141b4609103a4b2db51" => :sierra
    sha256 "25a34fbafc73386346451db63cffdfe2455d22a834a0510ff51d8bec925fbc3e" => :el_capitan
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
