class Vile < Formula
  desc "Vi Like Emacs Editor"
  homepage "https://invisible-island.net/vile/"
  url "https://invisible-island.net/archives/vile/current/vile-9.8y.tgz"
  sha256 "1b67f1ef34f5f2075722ab46184bb149735e8538fa912fc07c985c92f78fe381"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://invisible-island.net/archives/vile/current/"
    regex(/href=.*?vile[._-]v?(\d+(?:\.\d+)+[a-z]*)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "007220d4bfc4a658ffe56b9f4b1af2fa13cb8e8c2fe8cedd2d0537cba3efc8af"
    sha256 arm64_monterey: "38daf7cce4250fb7eb1b679dd1641c5e23706ed039731f95c3587dda288dac2b"
    sha256 arm64_big_sur:  "43f477324a6b277b54fe2f14d7cd9c3cac2f2d4e110bc9fa53bd611adc1f0cf3"
    sha256 ventura:        "674ad45785df6e65fd7ff6c23cb685d18bfc69a9efa94c6fc5ad3c7dc3b71f3e"
    sha256 monterey:       "f40b8db1d54f7bfe59600ab8153f706f12618489f085f232e092d5c771ddb768"
    sha256 big_sur:        "35ca3b5029b92d685e93e2a965869eb3460663b75d7fd818454f6ad02c887df9"
    sha256 x86_64_linux:   "cedd8f1889f10d2ce2ae2269963245e0e5e223f6dacc3a539c214cf5eaf0a328"
  end

  uses_from_macos "flex" => :build
  uses_from_macos "expect" => :test
  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"
  uses_from_macos "perl"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "groff" => :build
  end

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
