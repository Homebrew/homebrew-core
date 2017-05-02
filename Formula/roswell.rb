class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/v17.4.8.76.tar.gz"
  sha256 "c6a0715e962094801279cf5fb2c8efe71c6f9c134022a168198862d39a6193d1"
  head "https://github.com/roswell/roswell.git"

  bottle do
    sha256 "adb10a48749595bff549091e88cae94e0f0c8e44a97ed2625868be357cec2111" => :sierra
    sha256 "b63b68cc04b640188f84073abf2a181986a8288175e2d0900ad59ffedf560ad5" => :el_capitan
    sha256 "002e7f25da07189a09a54215f0ba1716def1983b1816223ce0d12d82c92edb9e" => :yosemite
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
