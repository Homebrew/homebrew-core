class Xkeyboardconfig < Formula
  desc "Keyboard configuration database for the X Window System"
  homepage "https://www.freedesktop.org/wiki/Software/XKeyboardConfig/"
  url "https://xorg.freedesktop.org/archive/individual/data/xkeyboard-config/xkeyboard-config-2.28.tar.bz2"
  sha256 "69adb25b0fc64e4075f8ec0eab8d869892419f474f91fb69db1713de2062bdce"
  license "MIT"
  head "https://gitlab.freedesktop.org/xkeyboard-config/xkeyboard-config.git"

  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "pkg-config" => [:build, :test]
  uses_from_macos "libxslt" => :build

  def install
    # Needed by intltool (xml::parser)
    ENV.prepend_path "PERL5LIB", "#{Formula["intltool"].libexec}/lib/perl5"

    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
      --with-xkb-rules-symlink=xorg
      --disable-runtime-deps
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    assert_predicate man7/"xkeyboard-config.7", :exist?
    assert_equal "#{share}/X11/xkb", shell_output("pkg-config --variable=xkb_base xkeyboard-config").chomp
    assert_match "Language: en_GB", shell_output("strings #{share}/locale/en_GB/LC_MESSAGES/xkeyboard-config.mo")
  end
end
