class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/v0.0.6.69.tar.gz"
  sha256 "39d812dcca63f11191f5fd11d12496b7ab194a3361538dde8cecab446f3be70e"
  head "https://github.com/roswell/roswell.git"

  bottle do
    sha256 "5c2d30d1639dbbc7b06dd8fb8099f5412e9efe4dc9c3833d99ed194a7346fef7" => :sierra
    sha256 "42de12541e41ba72374bb6015ce679cdc93fda5b2cbce1be34ea85779fcc50b4" => :el_capitan
    sha256 "dc74e6c21bc4d91859b50dd0c8cb45802ca5ea9a3b8c2293570108c99a228276" => :yosemite
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
