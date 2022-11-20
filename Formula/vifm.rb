class Vifm < Formula
  desc "Ncurses-based file manager with vi-like keybindings"
  homepage "https://vifm.info/"
  url "https://github.com/vifm/vifm/releases/download/v0.12.1/vifm-0.12.1.tar.bz2"
  sha256 "8fe2813ebdcccfe99aece02b05d62a20991525d46b0ccfbaec3af614c6655688"
  license "GPL-2.0-or-later"
  head "https://github.com/vifm/vifm.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "622d7635189b4ba60c1e26642efbb4b4f7fb5dbfb6b7f12c2da7e8457763d19e"
    sha256 arm64_monterey: "9ff2c110a2487990dc8a5473c4198e6c14d06076d2676945873ca6c79b7e1f5a"
    sha256 arm64_big_sur:  "a054a93a662f4280f6b374ca8587d4a7b37dbbc3ff34ea0926c391f68faf7f8c"
    sha256 ventura:        "7a00927b2058f0f9b48c035a9a69edc33d8b4d06b127c4fe9907bdabd78780a2"
    sha256 monterey:       "202faa12cccb273b6cb60b746d8dbbc96d80fe18da651d09adc9b954a151c8cb"
    sha256 big_sur:        "1e026dfdc6081bd33fb833c0694a25d30b588737bcac0a7e4588f10d2850ab3f"
    sha256 catalina:       "c1cd64539b149331b9c75cdaa309b73324d813a99aba93fe6943c070107e78a3"
    sha256 x86_64_linux:   "ce89d3ba9ff14eea964836c59269627de30a1c6707a44a5c55adabed035cd88d"
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
    # Run make check only when not root
    # https://github.com/vifm/vifm/issues/654
    system "make", "check" unless Process.uid.zero?

    ENV.deparallelize { system "make", "install" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vifm --version")
  end
end
