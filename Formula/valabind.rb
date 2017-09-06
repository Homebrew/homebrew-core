class Valabind < Formula
  desc "Vala bindings for radare, reverse engineering framework"
  homepage "https://radare.org/"
  revision 5

  head "https://github.com/radare/valabind.git"

  stable do
    url "https://www.radare.org/get/valabind-0.10.0.tar.gz"
    sha256 "35517455b4869138328513aa24518b46debca67cf969f227336af264b8811c19"

    # patch to support BSD sed
    # remove upon next release
    patch do
      url "https://github.com/radare/valabind/commit/03762a0fca7ff4bbfe3e668f70bb75422e05ac07.patch?full_index=1"
      sha256 "2d9eb2c9c1b64327bc444fc3fc94f7ef284535d9cf28d9ecf887859b253426b3"
    end
  end

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
    url "https://download.gnome.org/sources/vala/0.34/vala-0.34.9.tar.xz"
    sha256 "36662f77e36abf9ce6f46e3015c4512276e6361553bdcc2d75566ed83a1da19d"
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
