class Vile < Formula
  desc "Vi Like Emacs Editor"
  homepage "https://invisible-island.net/vile/"
  url "https://invisible-island.net/archives/vile/current/vile-9.8z.tgz"
  sha256 "0b3286c327b70a939f21992d22e42b5c1f8a6e953bd9ab9afa624ea2719272f7"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://invisible-island.net/archives/vile/current/"
    regex(/href=.*?vile[._-]v?(\d+(?:\.\d+)+[a-z]*)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "84034c614555bb446473e976341e350c73dcb4471d210c67fe602e958faef612"
    sha256 arm64_sonoma:   "e84be3fdb790f3335cd751171d55992f7bab1c53eebba6a06221a52665da04f4"
    sha256 arm64_ventura:  "cdaba9b9b3fc2a83aabc80a1b76481fa81bf861c0667d4c4e37929b4b92b5025"
    sha256 arm64_monterey: "a59ef3113b85e9b48da4bd05c297628d14aee271559257fc3bea1acac346ea72"
    sha256 sonoma:         "d6a9755cd33df24d243597f47dfb1da3c9e0708665e64167a0e1fe6ba036abda"
    sha256 ventura:        "9be509ddf2f63412f674624495e0e2c7e7475a21b448a0e027ae031c8b29bf25"
    sha256 monterey:       "7edd3946a1dced6529483b4f19816ff4b6d6a6310ad069f9d609f6b3a4803417"
    sha256 x86_64_linux:   "8fadd720ffa6b64bcdfe7fa7b99c76b79b452482aed43279b627ced5f285ac11"
  end

  uses_from_macos "flex" => :build
  uses_from_macos "expect" => :test
  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"
  uses_from_macos "perl"

  def install
    system "./configure", *std_configure_args,
                          "--disable-imake",
                          "--enable-colored-menus",
                          "--with-ncurses",
                          "--without-x",
                          "--with-screen=ncurses"
    system "make", "install"
  end

  test do
    ENV["TERM"] = "xterm"
    (testpath/"vile.exp").write <<~EOS
      spawn #{bin}/vile
      expect "unnamed"
      send ":w new\r:q\r"
      expect eof
    EOS
    system "expect", "-f", "vile.exp"
    assert_predicate testpath/"new", :exist?
  end
end
