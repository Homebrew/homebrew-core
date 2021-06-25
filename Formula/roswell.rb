class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/v21.06.14.110.tar.gz"
  sha256 "4649a495e55e3e04e3dae5890d318a170525cb01714661c412429f9503aeefd5"
  license "MIT"
  head "https://github.com/roswell/roswell.git"

  bottle do
    sha256 arm64_big_sur: "785be1d8190523c58b91aba74636b61e1dc395d00d993dc4b82e901d04017c10"
    sha256 big_sur:       "9cc57eb8499901954640e50f20cf1935f206a6f415d1812d4c875eec1361cf9c"
    sha256 catalina:      "274105c09c47e4aa6d586f970dd5f44da0e664db7f1c8a8f2b04691b2894c164"
    sha256 mojave:        "2b7ec4f359c16791326ac1a8ef064ba40e6dc758ed0b6b9c277cc13c12c1a6cf"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  uses_from_macos "curl"

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    ENV["ROSWELL_HOME"] = testpath
    system bin/"ros", "init"
    assert_predicate testpath/"config", :exist?
  end
end
