class Vile < Formula
  desc "Vi Like Emacs Editor"
  homepage "https://invisible-island.net/vile/"
  url "https://invisible-island.net/archives/vile/current/vile-9.8w.tgz"
  sha256 "78253ec3f7ae5f4f9d4799a3c8bc35b85b47d456f2ac172810008a48e4609815"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "0036bd77eb9f1231343f6e21793d6c3b1df01d014411b794aa289e621350a2ac"
    sha256 arm64_big_sur:  "440c832f9fb4513eea1800a0b1f22a7afae03f48f96d03478d78d731a76a84a0"
    sha256 monterey:       "4548060b0cf5731b7f4b6fc0eb95b33ea2a446decd83b5bfc946f354728d703b"
    sha256 big_sur:        "cda465c26af587b967d18c93061c25adc6cf0e356d5fee5bf172e8b671b47eea"
    sha256 catalina:       "b7b693bde291c3bdd649bfc2129aaeabf0c2e8edca732a458e427efcffcf3b28"
    sha256 x86_64_linux:   "bc15ead3a90e2e171890caa044d5279b54a017b7fb1bb7d83eaeccbb3f0e671e"
  end

  uses_from_macos "flex" => :build
  uses_from_macos "groff" => :build
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
