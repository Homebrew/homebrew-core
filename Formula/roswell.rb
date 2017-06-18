class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/v17.6.9.79.tar.gz"
  sha256 "46d3381d9dc8e424e78ddd7afef18f78bf695e82acb7441774f69718c634f0a3"
  head "https://github.com/roswell/roswell.git"

  bottle do
    sha256 "7aa2279a4c6ca84586f3cadc0ef00591e58dcf35e5032694eee0d2b70de622e0" => :sierra
    sha256 "349523e5e1f328fa2647a88a38db466bf209f56c923d247ee89e9df36d22dfc1" => :el_capitan
    sha256 "f5a7482fc23d1008f7be776f9ae1dc8498de2e33596d122c6e135634afa70fd7" => :yosemite
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
    assert_predicate testpath/"config", :exist?
  end
end
