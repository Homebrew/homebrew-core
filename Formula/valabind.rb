class Valabind < Formula
  desc "Vala bindings for radare, reverse engineering framework"
  homepage "https://radare.org/"
  url "https://github.com/radare/valabind/archive/1.4.0.tar.gz"
  sha256 "b2e4939912feada6138b8269d228ea82fb0f1391fd2e2e7003f404677b0cdbc9"
  head "https://github.com/radare/valabind.git"

  bottle do
    sha256 "6383f4c303ff8540f628bafe454a8ca30c7441542bed6bb2714126adb36605b5" => :sierra
    sha256 "1be71b4122e2719241c3a6be3aa47c96086495c509470bfd286f96d54847ba3a" => :el_capitan
    sha256 "e792ae4b975cea3ec03c19f2b458974afb9214e98ef5ca123419cb6f6ec4c6cf" => :yosemite
  end

  depends_on "pkg-config" => :run # :run, not :build, for vala
  depends_on "swig" => :run

  # vala dependencies
  depends_on "gettext"
  depends_on "glib"

  # Upstream issue "Build failure with vala 0.38.0"
  # Reported 6 Sep 2017 https://github.com/radare/valabind/issues/43
  resource "vala" do
    url "https://download.gnome.org/sources/vala/0.36/vala-0.36.5.tar.xz"
    sha256 "7ae7eb8a976005afecf4f647b9043f2bb11e8b263c7fe9e905ab740b3d8a9f40"
  end

  def install
    resource("vala").stage do
      system "./configure", "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{libexec}"
      system "make"
      system "make", "install"
    end

    ENV.prepend_path "PATH", libexec/"bin"
    ENV.prepend_path "PKG_CONFIG_PATH", libexec/"lib/pkgconfig"

    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"valabind", "--help"
  end
end
