class Vifm < Formula
  desc "Ncurses-based file manager with vi-like keybindings"
  homepage "https://vifm.info/"
  url "https://github.com/vifm/vifm/releases/download/v0.14.1/vifm-0.14.1.tar.bz2"
  sha256 "01f19e114e29f481d20faa6b35a42b883a3f487324ddb2f7107ce1c102c4a496"
  license "GPL-2.0-or-later"
  head "https://github.com/vifm/vifm.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "d42bbd65abb6dd248287efa95c048b635da1d6234007ce49c4d6a79805364980"
    sha256 arm64_sonoma:  "6578e3bd6cd66a91acefdadb102aa8ac732e7b0ce83c60da858379803e04ad72"
    sha256 arm64_ventura: "af13db929893b961f318f4bbc810495d74eae4f1a287aa3b85eed524e4b7fefb"
    sha256 sonoma:        "fbb0b81a0d33fa1261bed0aad03873d886d8186607d549ae58f23c436f4cdcff"
    sha256 ventura:       "09763481c3ae34dca7122f83beb04905cd3603e0678be6673df54836fa2ba681"
    sha256 arm64_linux:   "eb189220e297f0584aa4659a0364c367857247568139d71b9221c00e5a474919"
    sha256 x86_64_linux:  "35efcfbcb43d8da80932740a39bfd6c2f84e2f173bd2fee994ba479ba61fc7c1"
  end

  depends_on "ncurses"

  uses_from_macos "mandoc" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-curses=#{Formula["ncurses"].opt_prefix}",
                          "--without-gtk",
                          "--without-libmagic",
                          "--without-X11"
    system "make"
    system "make", "check"

    ENV.deparallelize { system "make", "install" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vifm --version")
  end
end
