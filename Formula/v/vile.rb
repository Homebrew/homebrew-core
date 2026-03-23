class Vile < Formula
  desc "Vi Like Emacs Editor"
  homepage "https://invisible-island.net/vile/"
  url "https://invisible-island.net/archives/vile/current/vile-9.8zb.tgz"
  sha256 "d6239e6b728fa9d0b49f526d8f0998d2db4b7a7dfc317273dbff7aea2a09ea31"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://invisible-island.net/archives/vile/current/"
    regex(/href=.*?vile[._-]v?(\d+(?:\.\d+)+[a-z]*)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "ae7efab15213d0ae0107d3a433ff1c7f4b76b1edb01cc03939d186cd4ce98131"
    sha256 arm64_sequoia: "3c5aad26fe9462da4a3a634c6ac8799ee3d8350b897e497bdf3e92051ad38033"
    sha256 arm64_sonoma:  "ca644c2182d7595c99e6666d5f12d5ef2756f65010d4c13db6e896266ff0c847"
    sha256 sonoma:        "c632b20a8b7bbc9e29711ee11e378a1c6b45767b7a671c9c0ddcb7196b7e2935"
    sha256 arm64_linux:   "b3c3045a3194a913336c2f3e5c4e1d9de9c8f75f2ee4afb945981d36fce94f31"
    sha256 x86_64_linux:  "d24ec87b3504534f464ab320b1ba0ba57fc907eac2eea4072116c1b751c1c032"
  end

  uses_from_macos "flex" => :build
  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"
  uses_from_macos "perl"

  def install
    system "./configure", "--disable-imake",
                          "--enable-colored-menus",
                          "--with-ncurses",
                          "--without-x",
                          "--with-screen=ncurses",
                          *std_configure_args
    system "make", "install"
  end

  test do
    require "pty"
    ENV["TERM"] = "xterm"
    PTY.spawn(bin/"vile") do |r, w, _pid|
      w.write "ibrew\e:w new\r:q\r"
      r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
    assert_path_exists testpath/"new"
    assert_equal "brew\n", (testpath/"new").read
  end
end
