class Solfege < Formula
  desc "GNU Solfege is an ear training program"
  homepage "https://www.gnu.org/software/solfege/"
  url "https://ftp.gnu.org/gnu/solfege/solfege-3.22.2.tar.bz2"
  mirror "https://ftpmirror.gnu.org/solfege/solfege-3.22.2.tar.bz2"
  sha256 "5a6fcd46b0ce33817752f5b04e053b5342d8d2e3c8b3df2ea789cf3366a38b10"

  depends_on "gettext"      => :build
  depends_on "pkg-config"   => :build
  depends_on "librsvg"
  depends_on "pygtk"
  depends_on "timidity"     => :recommended
  depends_on "mpg123"       => :optional
  depends_on "vorbis-tools" => :optional

  def install
    inreplace "Makefile.in", "cp --parents", "rsync -R"
    inreplace "default.config", "/usr/bin/", "#{HOMEBREW_PREFIX}/bin/"
    inreplace "solfege/mainwin.py", "webbrowser.open(filename)", "webbrowser.open(\"file://\" + filename)"

    system "./configure", "--prefix=#{prefix}", "--disable-oss-sound"
    system "make", "install"
  end

  test do
    system "#{bin}/solfege", "--version"
  end
end
