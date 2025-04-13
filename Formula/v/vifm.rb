class Vifm < Formula
  desc "Ncurses-based file manager with vi-like keybindings"
  homepage "https://vifm.info/"
  url "https://github.com/vifm/vifm/releases/download/v0.14/vifm-0.14.tar.bz2"
  sha256 "2714dd4cef4e53e7a8980ae8445e88279104f815d47f417fa0b8adfe2f3d1bed"
  license "GPL-2.0-or-later"
  head "https://github.com/vifm/vifm.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "27810e8910509e596830ed45a0d5586b2bb559c4cc8f14c1ab3840d4b8cc4aa7"
    sha256 arm64_sonoma:  "7e645734ff739c91b757c6fbe07d7d07107a23640ef9ab16f1e8bb885730ca5c"
    sha256 arm64_ventura: "572237eca7ffce7d969291acbd21469d590f5aa867f5c0cd2937ad983feec1a8"
    sha256 sonoma:        "76ae8ef7d70626c281a9d6742862a8fa2c737c82434aad4f8020365af38f0e92"
    sha256 ventura:       "09d3e74801f83d194e850fe8186501cfba5ce89cf3d4a75eaeb3931145cea90c"
    sha256 arm64_linux:   "c759e2c726f4980b60f6dadbd720a7cca58e16a86f51196847e251f97cc4ff54"
    sha256 x86_64_linux:  "f03f7243697b0524068c3fbd9efdc301d2e5079efbaaba3d5e7ee002d5393642"
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
