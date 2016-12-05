class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/v16.11.7.70.tar.gz"
  sha256 "4df54132d9113fa08110c0d23c9536f1b1aaf5bf7956800548478a6b2cdee346"
  head "https://github.com/roswell/roswell.git"

  bottle do
    sha256 "f3b4401a5bee586c2f008c50d3554bce74bee3d43b57fb0fad2c6b543aa01e8c" => :sierra
    sha256 "c06cc79941208915fe94d9f6eaa785fca7b3b65d43c91a7040cdc59486ed89b1" => :el_capitan
    sha256 "d58c249867099db4e4a30c594ff0fb8bd6b6572ef4cb3717fa2a0b743ffedb35" => :yosemite
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
