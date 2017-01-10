class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/v16.12.8.72.tar.gz"
  sha256 "c73ad5763257729eaf8b28876ddca4fcc5dd7b83b955db82ab9af95cd25ad02d"
  head "https://github.com/roswell/roswell.git"

  bottle do
    sha256 "6ba4d7e688f8c9d784d1eac08cd4cb0e85c1d330c7a95e63beffef8527578838" => :sierra
    sha256 "6189d27d2ac1c3444e49295104f4b3837b7b594e373a74b845a7c647cfe9e4df" => :el_capitan
    sha256 "51c247c225060bf32db5463987b88b01776462cf08814c29c79699970d0a95f2" => :yosemite
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
