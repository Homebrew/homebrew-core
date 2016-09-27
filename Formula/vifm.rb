class Vifm < Formula
  desc "Ncurses based file manager with vi like keybindings"
  homepage "https://vifm.info/"
  url "https://github.com/vifm/vifm/releases/download/v0.8.2/vifm-0.8.2.tar.bz2"
  sha256 "8b466d766658a24d07fc2039a26fefc6a018f5653684a6035183ca79f02c211f"

  bottle do
    sha256 "c371771e464449ebc7d8ef84c89f0b9b75eccc91bf1f1d35ca7b9d38bca885f7" => :sierra
    sha256 "cd87c86ced448263187664d65b06a627a311d0ea456a6eda4c68bddadca82de6" => :el_capitan
    sha256 "0967f7e9dce7d0fa2572e897532dea2af274726a944a518c13119547a2b4f699" => :yosemite
    sha256 "7cf24c1685bbf8b4cdc799f3f6ff767809207dd72b1f2f121d1a7b74c6c909c4" => :mavericks
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
