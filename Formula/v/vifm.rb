class Vifm < Formula
  desc "Ncurses-based file manager with vi-like keybindings"
  homepage "https://vifm.info/"
  url "https://github.com/vifm/vifm/releases/download/v0.14.5/vifm-0.14.5.tar.bz2"
  sha256 "5de33fd6637ce91cdce162358ec393f6fe5e9734deb1833ea16776d619960422"
  license "GPL-2.0-or-later"
  head "https://github.com/vifm/vifm.git", branch: "master"

  bottle do
    sha256 arm64_golden_gate: "4c42284c284ae3d471ec352888ebd96f1c05b7875322d2b220a48319ef940f3f"
    sha256 arm64_tahoe:       "7ff33180ccb9c5fe8a4cfbf0c13b5abfd73d4baf9a5ec972e5daec799ca3ae9f"
    sha256 arm64_sequoia:     "b651ad7b0043153119dced70de580555b19bdeb76b47e11a6e8aae37b218c8b3"
    sha256 arm64_linux:       "95d4b78ea9b179715d6f2a8865c3fdb556272c6af912d58f3fc1c8cb968171a8"
    sha256 x86_64_linux:      "61a664205e4d0b405371c675eff792bc80ff6065d20122642af46c35899a1a49"
  end

  depends_on "ncurses"

  uses_from_macos "mandoc" => :build

  deny_network_access!

  def install
    args = %W[
      --with-curses=#{formula_opt_prefix("ncurses")}
      --without-gtk
      --without-libmagic
      --without-X11
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    ENV.deparallelize { system "make", "install" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vifm --version")
  end
end
