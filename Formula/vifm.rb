class Vifm < Formula
  desc "Ncurses based file manager with vi like keybindings"
  homepage "https://vifm.info/"
  url "https://github.com/vifm/vifm/releases/download/v0.11/vifm-osx-0.11.tar.bz2"
  sha256 "d6f829ed0228a8f534d63479fc988c2b4b95e6bc49d5db5e4fabff337fba3c4c"
  license "GPL-2.0-or-later"
  head "https://github.com/vifm/vifm.git", branch: "master"

  bottle do
    sha256 arm64_big_sur: "32f0bfc374eab7c8d62cbec5febbbd7fce07610bc34a9a99f9a6581f14c3ba17"
    sha256 big_sur:       "4ca7e104a550c3119e4a728151ba26b3c3561fd00d36ecbd3171907946d69202"
    sha256 catalina:      "d10ee88a7127716193fdfaad429e7c5c09f6a37c4b8b5ef78ba9cbb24229f4fa"
    sha256 mojave:        "fef03d352df4b86b94a5e529a6eb54fd4ffea6584fba2ab6e4bc8c6af2bae83d"
    sha256 high_sierra:   "9391d61f7b0cd098ce66789b3917e3b5d0e74104d309918980d94623c4cacac4"
    sha256 x86_64_linux:  "55a47c9d20e9ef3b4e943ce24a33403ab02afa9b694fd848b938d4b5385b786b"
  end

  uses_from_macos "groff" => :build
  uses_from_macos "ncurses"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-gtk",
                          "--without-libmagic",
                          "--without-X11"
    system "make"
    # Run make check only when not root
    # https://github.com/vifm/vifm/issues/654
    system "make", "check" unless Process.uid.zero?

    ENV.deparallelize { system "make", "install" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vifm --version")
  end
end
