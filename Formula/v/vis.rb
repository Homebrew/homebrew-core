class Vis < Formula
  desc "Vim-like text editor"
  homepage "https://github.com/martanne/vis"
  url "https://github.com/martanne/vis/archive/v0.8.tar.gz"
  sha256 "61b10d40f15c4db2ce16e9acf291dbb762da4cbccf0cf2a80b28d9ac998a39bd"
  license "ISC"
  head "https://github.com/martanne/vis.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "d645f9d687468ef9df01b7553ba153010e0c11cf61efeed8613ed0f69d8ab8ec"
    sha256 arm64_ventura:  "32908c8b3e0251376b5a5020fde49c276c652a71eeee6a624dea98ab61211260"
    sha256 arm64_monterey: "4175e1489036cb6b42e68c2073e4b5626cfb2ae3fadfba52e2e32d0a7e324dc3"
    sha256 arm64_big_sur:  "067127470533d46e86b8ef7c6aba0e203061347fa1e6a74933e0fbc833d81ff2"
    sha256 sonoma:         "f4f517e6eef8fd53dc1a662b06a2e14dcc880d7bf0a93bc732bc4bb5497eeeab"
    sha256 ventura:        "8311b635e107ec0cb5282cf86920bee36d5cc32219fb9b41a0b77f0980c4b745"
    sha256 monterey:       "fc879a20d56fbe7eb9956dda54fd0f603f4d14d4a3f903462946f23fba5766a0"
    sha256 big_sur:        "6d2d2178c60f3d091818d80c9e9c86744e946661f1dede662d3b248c2cb1a858"
    sha256 x86_64_linux:   "98848b044f51a151d7ca4cc2ad97b8d1c33a1002c3dd3eb2ce27ef6be0fd263c"
  end

  depends_on "pkg-config" => :build
  depends_on "libtermkey"
  depends_on "lpeg"
  depends_on "lua"

  uses_from_macos "unzip" => :build
  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-lua"
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
