class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/v17.7.9.80.tar.gz"
  sha256 "20e5a99a5865a906874c5361edd79e80445e8cb62d633aa55b77454eb798077a"
  head "https://github.com/roswell/roswell.git"

  bottle do
    sha256 "84c4474ba885090a3c9a6e82234095bfe1a5092021ca8176b77e1d525a7854f0" => :sierra
    sha256 "9bd1589b3a3ecf2336e0b3ff6a4b5b6561fd680d4d7cc858f147d17207babc31" => :el_capitan
    sha256 "a445cd68dde8e98806a99ad32c3d5acd2e9183ef1ba84da154822dfb4357c943" => :yosemite
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
