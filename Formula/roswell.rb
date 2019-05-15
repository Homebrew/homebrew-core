class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/v19.4.10.98.tar.gz"
  sha256 "5783431ef096840dd5696b448c76e66e8805e53bd7ac6fb572734e3ffd969649"
  head "https://github.com/roswell/roswell.git"

  bottle do
    sha256 "2f778c029c5147f2bf988061a9e92b1d1f9a388a7fbe6a6dfa3518f0da149055" => :mojave
    sha256 "27228b25947a7f083d717eb35ae6fb048d133f3c84c0429138626216c804ec16" => :high_sierra
    sha256 "4f15f5f2b8cfdcc0556df7953735d4dd1cbdcdf342a807e07484cf7384a95b9a" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

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
