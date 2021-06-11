class Xkeyboardconfig < Formula
  desc "Keyboard configuration database for the X Window System"
  homepage "https://www.freedesktop.org/wiki/Software/XKeyboardConfig/"
  url "https://xorg.freedesktop.org/archive/individual/data/xkeyboard-config/xkeyboard-config-2.33.tar.bz2"
  sha256 "657fd790d6dcf781cd395de4cf726120a5b0f93ba91dfb2628bcc70ae8b1d3bc"
  license "MIT"
  head "https://gitlab.freedesktop.org/xkeyboard-config/xkeyboard-config.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "24e5f5e5a8367296bf39a7a4d6e821beea5030ba613bcebe6a19cefa5ddb5cc6"
    sha256 cellar: :any_skip_relocation, big_sur:       "8baa880e15f628d34d896a1132b99923b64df53794ddb29cb366fa3272b46495"
    sha256 cellar: :any_skip_relocation, catalina:      "292c62a8b20d29a384c7f8140205e3d9a2a5d21bc3364426e3540b874a6396e0"
    sha256 cellar: :any_skip_relocation, mojave:        "fe7a46767c174a67d05b3342611d112716441f8d5e7f13a9c317f64b59cca3dd"
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
