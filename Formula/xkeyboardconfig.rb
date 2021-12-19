class Xkeyboardconfig < Formula
  desc "Keyboard configuration database for the X Window System"
  homepage "https://www.freedesktop.org/wiki/Software/XKeyboardConfig/"
  url "https://xorg.freedesktop.org/archive/individual/data/xkeyboard-config/xkeyboard-config-2.34.tar.bz2"
  sha256 "b321d27686ee7e6610ffe7b56e28d5bbf60625a1f595124cd320c0caa717b8ce"
  license "MIT"
  head "https://gitlab.freedesktop.org/xkeyboard-config/xkeyboard-config.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e38b424812f6c9a373e850a76fadb56e6fc9a0545885fa5ac5869f064c4decf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e38b424812f6c9a373e850a76fadb56e6fc9a0545885fa5ac5869f064c4decf"
    sha256 cellar: :any_skip_relocation, monterey:       "0e38b424812f6c9a373e850a76fadb56e6fc9a0545885fa5ac5869f064c4decf"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e38b424812f6c9a373e850a76fadb56e6fc9a0545885fa5ac5869f064c4decf"
    sha256 cellar: :any_skip_relocation, catalina:       "0e38b424812f6c9a373e850a76fadb56e6fc9a0545885fa5ac5869f064c4decf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28e78229dda1c08ec348dc229354d8039f7632dffa2603319a48942718984fe3"
  end

  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "python@3.10" => :build
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
