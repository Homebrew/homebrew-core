class Xboard < Formula
  desc "Graphical user interface for chess"
  homepage "https://www.gnu.org/software/xboard/"
  license "GPL-3.0-or-later"
  revision 4

  stable do
    # TODO: Switch to GTK+3 build on next release (see HEAD build)
    url "https://ftpmirror.gnu.org/xboard/xboard-4.9.1.tar.gz"
    mirror "https://ftp.gnu.org/gnu/xboard/xboard-4.9.1.tar.gz"
    sha256 "2b2e53e8428ad9b6e8dc8a55b3a5183381911a4dae2c0072fa96296bbb1970d6"

    depends_on "libx11"
    depends_on "libxaw"
    depends_on "libxmu"
    depends_on "libxt"

    # Fix `--help` abort under `_FORTIFY_SOURCE=3`, reported upstream to <bug-xboard@gnu.org>
    patch :DATA
  end

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "74171650ea32aaa60891345f4d72f953901bfa37df649b6c229b78ea4865107c"
    sha256 arm64_tahoe:       "53d55768d79426bf00e69bf7db2a9a05a53c7f9b0b8dd7545f988e50e79f990a"
    sha256 arm64_sequoia:     "d667ffcdbf166279d7cfdad4d6f21f53a8e44639d5bb211e70199f005681027a"
    sha256 arm64_linux:       "c0d6a2a152c01dd748ebc1a88404ba01f97e0ededd8a9a7f6c4669c65b34031f"
    sha256 x86_64_linux:      "814476c1bfed7cc7ca7302269e5828e5addf1d6a6ded74b181f2ff2fcaae5529"
  end

  head do
    url "https://git.savannah.gnu.org/git/xboard.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "gtk+3"

    on_macos do
      depends_on "gettext"
    end
  end

  depends_on "pkgconf" => :build
  depends_on "cairo"
  depends_on "fairymax" => :no_linkage
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "librsvg"
  depends_on "pango"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    ENV.append_to_cflags "-fcommon" if OS.linux?
    ENV.append "LDFLAGS", "-Wl,-dead_strip_dylibs" if OS.mac?

    args = %w[
      --disable-silent-rules
      --disable-zippy
    ]
    if build.stable?
      args += %w[
        --disable-nls
        --with-Xaw
        --without-gtk
      ]
    else
      system "autoreconf", "--force", "--install", "--verbose"
    end
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"xboard", "--help"
  end
end

__END__
--- a/xaw/xboard.c
+++ b/xaw/xboard.c
@@ -963,7 +963,7 @@
          " Persistent options (saved in the settings file) are marked with *)\n\n");
   while(p->argName) {
     if(p->argType == ArgCommSettings) { p++; continue; } // XBoard has no comm port
-    snprintf(buf+len, MSG_SIZ, "-%s%s", p->argName, PrintArg(p->argType));
+    snprintf(buf+len, MSG_SIZ-len, "-%s%s", p->argName, PrintArg(p->argType));
     if(p->save) strcat(buf+len, "*");
     for(q=p+1; q->argLoc == p->argLoc; q++) {
       if(q->argName[0] == '-') continue;
