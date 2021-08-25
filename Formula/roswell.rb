class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/v21.06.14.110.tar.gz"
  sha256 "4649a495e55e3e04e3dae5890d318a170525cb01714661c412429f9503aeefd5"
  license "MIT"
  head "https://github.com/roswell/roswell.git", branch: "master"

  bottle do
    sha256 arm64_big_sur: "a175b1f7c4f29305cd4ae65c2dc516d2a017e1afa6bf3111793b9ca46923e4bf"
    sha256 big_sur:       "633680e3f581ec760fdbf9d559de97ec01443663f814600b6ce2ff6e55b28ee6"
    sha256 catalina:      "327cea9e5eebd0c6aa57eda3a01fb0487c36412b24397a85d411a995b5efcecf"
    sha256 mojave:        "35d4e37825ad03c973e6e95caedb293cd6d055b06825d2d5ce089c9777e8db72"
    sha256 x86_64_linux:  "6d720637cfaef4b37befa95342ac65fa408f80daef9ab7122e376001b5161a37"
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
