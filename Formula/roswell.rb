class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/v0.0.6.66.tar.gz"
  sha256 "322ea804252f71e97e2d676e428334b6eab751dcd5df1a0a232d508869d31894"
  head "https://github.com/roswell/roswell.git"

  bottle do
    sha256 "c86ef56af7f92ee4c088503e8c3683045cb71653af4705dae7ff957dad7d617b" => :sierra
    sha256 "ebf4dc986cc82737b3f8c953f4f5ce20d372be5f2b42b2cb1f91d79d26cbe33e" => :el_capitan
    sha256 "004394c3b7f5199dab8e68ec4107ccfa8e35de6935ae0320c91d2efdb9ef84c5" => :yosemite
    sha256 "639fa7bb1f504a3f7bc1f71b9527f4b29c2d6d38acffd7fa5768957710091951" => :mavericks
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-manual-generation",
                          "--enable-html-generation",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    ENV["ROSWELL_HOME"] = testpath
    system bin/"ros", "init"
    File.exist? testpath/".roswell/config"
  end
end
