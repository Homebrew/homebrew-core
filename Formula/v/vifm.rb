class Vifm < Formula
  desc "Ncurses-based file manager with vi-like keybindings"
  homepage "https://vifm.info/"
  url "https://github.com/vifm/vifm/releases/download/v0.14.2/vifm-0.14.2.tar.bz2"
  sha256 "cd1b05d2543cdf6829d60b23bc225c6fde13d3ef7c1008f821b9209837f1e2b0"
  license "GPL-2.0-or-later"
  head "https://github.com/vifm/vifm.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "9276255fe9b32995b3eae789f1d36a8392aa8b8660687ccaf72254f3f38cbbc9"
    sha256 arm64_sonoma:  "8f9fb46f4484435937bef4a659c1fb3c2b9c76d5b0cd34ef982dd709aec0805e"
    sha256 arm64_ventura: "2058d4a40e37ed15822c06e2f2c27fd299f15d992a177daaf88d419d27224c38"
    sha256 sonoma:        "2a7cde7ab932811531b08addaea260eaebe721053dd7c655cd67dab342755251"
    sha256 ventura:       "df22d2e5dae7db8ac5724c3fae19e9f8b8b15f8b75205b0f98360ce438a3c9b4"
    sha256 arm64_linux:   "8009c37ce7a2fce889c16ef9e6506e9916e5b33213ce8e22e09adad77206d8d7"
    sha256 x86_64_linux:  "3eb75803e9f5796343cee46031d84d69a5e245ad90ce3ebd875b5dffd9002f82"
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
