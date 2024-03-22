class Vis < Formula
  desc "Vim-like text editor"
  homepage "https://github.com/martanne/vis"
  url "https://github.com/martanne/vis/archive/refs/tags/v0.8.tar.gz"
  sha256 "61b10d40f15c4db2ce16e9acf291dbb762da4cbccf0cf2a80b28d9ac998a39bd"
  license "ISC"
  revision 1
  head "https://github.com/martanne/vis.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "7ccde2ec515147e2dfa391aa9c13e02c56d9100ddaa1fe0648d0a44256baeee6"
    sha256 arm64_ventura:  "c7bd78e7dc1d66f187844ec7261fca802f5b65157bd15a93688d0b888a07b63c"
    sha256 arm64_monterey: "5a474c5a0f86dfa5c2deaa03ff4253606c8b6e332e506cbe5bf38c73c119e026"
    sha256 sonoma:         "dae6e06a6083b3ec751df19b838dcf589cf5a5409e86b7dae41419f7c01f82c8"
    sha256 ventura:        "0e2d2df60725dbb0f281e833a49f32b84ac37adfc001c9083919f866f590c90f"
    sha256 monterey:       "537cabe01b0048f555cc62c7e7336ec5175fa3aa041f32270d6500b48e0ac007"
    sha256 x86_64_linux:   "c1e9611e3b0342cd639047550c81622218c4ed2df4dd6094ca07ca5d8d9bd335"
  end

  depends_on "pkg-config" => :build
  depends_on "libtermkey"
  depends_on "lpeg"
  depends_on "lua"

  uses_from_macos "unzip" => :build
  uses_from_macos "ncurses"

  def install
    system "./configure", "--enable-lua", "--enable-lpeg-static=no", *std_configure_args
    system "make", "install"

    return unless OS.mac?

    # Rename vis & the matching manpage to avoid clashing with the system.
    mv bin/"vis", bin/"vise"
    mv man1/"vis.1", man1/"vise.1"
  end

  def caveats
    on_macos do
      <<~EOS
        To avoid a name conflict with the macOS system utility /usr/bin/vis,
        this text editor must be invoked by calling `vise` ("vis-editor").
      EOS
    end
  end

  test do
    binary = if OS.mac?
      bin/"vise"
    else
      bin/"vis"
    end

    assert_match "vis #{version} +curses +lua", shell_output("#{binary} -v 2>&1")
  end
end
