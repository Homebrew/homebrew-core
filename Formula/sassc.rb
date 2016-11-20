class Sassc < Formula
  desc "Wrapper around libsass that helps to create command-line apps"
  homepage "https://github.com/sass/sassc"
  url "https://github.com/sass/sassc.git", :tag => "3.3.6", :revision => "e32c23dafbad59e757d5a3aab153e5f3a01cb6ab"
  head "https://github.com/sass/sassc.git"

  bottle do
    cellar :any
    sha256 "f59af4d6364440102506fe9d92921a0dd9bcffab9bc2a620c1be637d416cb10c" => :sierra
    sha256 "534c0fc0ae6e79accb16da5e9ffef0900924fac876a4364ce78c5513a0a55083" => :el_capitan
    sha256 "ccc9448a322b91eb877893f7978f0f1fea9edc79853d76dec7a16047d921ef4e" => :yosemite
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
