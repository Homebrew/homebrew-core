class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/v21.10.14.111.tar.gz"
  sha256 "d1eb3e93b3aa6327d34d06fe14796a52f98fd7588092e6dbe2cabd0b8fbd7c92"
  license "MIT"
  head "https://github.com/roswell/roswell.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "a4836347f8eeda68150c9bd93428745b8070777c0b276cfdbdbf36c72508af25"
    sha256 arm64_big_sur:  "bffc26ea2001882e4533559498e679743013eb90c589c93609ea03b280741a46"
    sha256 monterey:       "0fca96c4724cc410f90ad0baf56918b79e73c3bb16e7214c8f649f9f709b4b91"
    sha256 big_sur:        "d8311cd5af1da8ef5acf318de6d145ae9cca55cf2958a8406f0adb497778bb4f"
    sha256 catalina:       "e58a6ce3601111e929e2bdd5cc9273a4e3b998f01439f7297a30e7317ac8d75f"
    sha256 mojave:         "2647b1cbeecbbd8717a6978b765fa045f10e8de5a3e2ef1a99fe120086287e34"
    sha256 x86_64_linux:   "6bd1affee09ea73aba10752a6e52da528593c6a327cc4b0a2c8822fc24261434"
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
