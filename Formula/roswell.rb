class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/v21.01.14.108.tar.gz"
  sha256 "b35ff6f71c63efee86d93e59b4a4a726c955c66ccaa04929b4ea8b55fe4e3825"
  license "MIT"
  head "https://github.com/roswell/roswell.git"

  bottle do
    sha256 big_sur:  "b7db531bc082e7d5a718db112cad8342440da1191b3a2df6281366bcf96ba83f"
    sha256 catalina: "0ede39e73ddf6da472a7792ace6af330fe1365b29a0ee5d3795ff735821afe3d"
    sha256 mojave:   "56d1d761a10659d41afd718cd4b37bca7ff80f26e8c62ef7f493d6f571e37606"
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
