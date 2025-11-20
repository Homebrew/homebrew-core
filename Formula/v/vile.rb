class Vile < Formula
  desc "Vi Like Emacs Editor"
  homepage "https://invisible-island.net/vile/"
  url "https://invisible-island.net/archives/vile/current/vile-9.8za.tgz"
  sha256 "65ba15ec145dfc5506217162228c7d88f01c0490a0dccde7a8a19f1c7c1b93b2"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://invisible-island.net/archives/vile/current/"
    regex(/href=.*?vile[._-]v?(\d+(?:\.\d+)+[a-z]*)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "7d79abf379edd20ee6cfbea6ee0083c4523bf15d2548a54c26f522ef7056989d"
    sha256 arm64_sequoia: "7728979664a4c7edf21462cc0b8f92b142afb086ec09f25c95655ae505987f96"
    sha256 arm64_sonoma:  "5f69aa47ad920cc7457274cbed9e6b9f7df93ae5212f95e32e67dc052fd5aa1f"
    sha256 arm64_ventura: "1da870f5170e7ec88f561de66a0cc33ef311aff1286cc75fb81dcce222199438"
    sha256 sonoma:        "d9b590f1bfa6fd0babaf72eed46cbecdb5e18c80e559451f8532af8771059e2f"
    sha256 ventura:       "f9128012e729d2813788f6fa74366538105c6894bdc5955667f298cbaa3a3818"
    sha256 arm64_linux:   "d567c9686cfda46b23c1f9a9fbd3f94b7b7d769dca59646e234673ac2c67b80f"
    sha256 x86_64_linux:  "9ec063cf33a1aaf4f5fa4f4d5eb0fb953b31c6ce159d7d171b5269db6a276f77"
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
