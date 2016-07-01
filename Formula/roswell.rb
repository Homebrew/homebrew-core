class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/v0.0.6.64.tar.gz"
  sha256 "f9b7a3ada298e62d024b612136196d8564e36650da59b6cc72cfb6c9bdaca3c1"
  head "https://github.com/roswell/roswell.git"

  bottle do
    sha256 "9c37759a79a0acc4a489d9be82b1a95ebdc4cf8a312c3970ff968098a5eda3f4" => :el_capitan
    sha256 "57ba2b5b58256e179241d0a2ec952cb4bec5a1f57ceb7a85f3a02af8b20d1eea" => :yosemite
    sha256 "b059bbf0eab705343e3c45efb96b4d2e8f1cd91bf6dbb52e484f39f323118a19" => :mavericks
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
