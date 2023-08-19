class Vifm < Formula
  desc "Ncurses-based file manager with vi-like keybindings"
  homepage "https://vifm.info/"
  url "https://github.com/vifm/vifm/releases/download/v0.13/vifm-0.13.tar.bz2"
  sha256 "0d9293749a794076ade967ecdc47d141d85e450370594765391bdf1a9bd45075"
  license "GPL-2.0-or-later"
  head "https://github.com/vifm/vifm.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "dc48e8783bdc17a9b47dd55f3ed52d26903219e98c0e06f1a8111945ae3f7c52"
    sha256 arm64_monterey: "6f355ca3cbcb187ee2c532df543bc6397be271f8d17bab414a71bed297f82278"
    sha256 arm64_big_sur:  "8b675c527a9f72e79c78a11631954e76abbc46ebba233d01b3ce90dbc5dccc7d"
    sha256 ventura:        "80c51d396cda06ab3f5a0da762d5fcd0230706329313a894bb7c3396ea9dfe18"
    sha256 monterey:       "e0221857eab3abb6726d0608a028a75c0aaa5acaee7c28c72b555db9fa3d5492"
    sha256 big_sur:        "cd22ccc9929ca7af51f74382ef100b71f0e2197f570e6a857214bacb38a2ef4f"
    sha256 x86_64_linux:   "62cff341649c356910f64b26912563147957e19aacb58efef991492b3e461224"
  end

  uses_from_macos "ncurses"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "groff" => :build
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
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
