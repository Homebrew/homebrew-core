class Xkeyboardconfig < Formula
  desc "Keyboard configuration database for the X Window System"
  homepage "https://www.freedesktop.org/wiki/Software/XKeyboardConfig/"
  url "https://xorg.freedesktop.org/archive/individual/data/xkeyboard-config/xkeyboard-config-2.31.tar.bz2"
  sha256 "da44181f2c8828789c720decf7d13acb3c3950e2a040af5132f50f04bb6aada3"
  license "MIT"
  head "https://gitlab.freedesktop.org/xkeyboard-config/xkeyboard-config.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5d2d8508d8ea7a1aeb33520285088526d460f3e796911bde60af52e0fee0cab7" => :big_sur
    sha256 "ed5f4d5be9381ef91eadba64cf368ab3e4b0e7d490a5b472097c8671a837e83b" => :arm64_big_sur
    sha256 "657ec08d8201cd932171f8f9acecd94e62f66657ea7c730810fb2dec70e17c1f" => :catalina
    sha256 "20a9ec45d3b7fbeca4dfd3bef4dff0108e7ed2481a2b3256c0dd4f152b996de5" => :mojave
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
