class Xkeyboardconfig < Formula
  desc "Keyboard configuration database for the X Window System"
  homepage "https://www.freedesktop.org/wiki/Software/XKeyboardConfig/"
  url "https://xorg.freedesktop.org/archive/individual/data/xkeyboard-config/xkeyboard-config-2.31.tar.bz2"
  sha256 "da44181f2c8828789c720decf7d13acb3c3950e2a040af5132f50f04bb6aada3"
  license "MIT"
  head "https://gitlab.freedesktop.org/xkeyboard-config/xkeyboard-config.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "914f4d2b2f99366532b6966a45f58da6be6bd391e1f162d1aca512341aab6298" => :big_sur
    sha256 "2bc4ef4bb2f03b72f8ceb8c4fb12048c8dfda6c4db24f7fa2cf6b19f4ba54b17" => :catalina
    sha256 "347f0195f728cbff5e9e2330248d1d195e8fb198134572bd66d1f45fb4449c10" => :mojave
    sha256 "8350bb43f9ae136e0d3a811230d351ce741c63ba2ba1e9901d63b009cf6f588e" => :high_sierra
  end

  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "python@3.9" => :build
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
