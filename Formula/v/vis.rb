class Vis < Formula
  desc "Vim-like text editor"
  homepage "https://github.com/martanne/vis"
  url "https://github.com/martanne/vis/archive/refs/tags/v0.9.tar.gz"
  sha256 "bd37ffba5535e665c1e883c25ba5f4e3307569b6d392c60f3c7d5dedd2efcfca"
  license "ISC"
  revision 1
  head "https://github.com/martanne/vis.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "48f1f7959be85ddf700d6a18f71e5f1597a490e2679f81038aac4506c3f33472"
    sha256 arm64_sequoia: "c4cff2af4d8434d9c01314c8020c3831b3047fe2868c33c31210fbe13ed74ce6"
    sha256 arm64_sonoma:  "bd83067d95abd29e175739d0ccb942008d3a77e8af0fd005073c1bff33a1516c"
    sha256 sonoma:        "a7460f4c478624d321fcbf3c5eb60d323481d485e5448b295893ece018c17fef"
    sha256 arm64_linux:   "21494a89af0e59a06cdd78d618c4de6dbe67b2d38421efc88f7500320dfe7b8f"
    sha256 x86_64_linux:  "9e56addec38aa4ab41947607ed671c38dfa96e4eb0323890579d87ee4aeae839"
  end

  depends_on "pkgconf" => :build
  depends_on "libtermkey"
  depends_on "lpeg"
  depends_on "lua@5.4" # https://github.com/martanne/vis/commit/b8fea9bcb14ea10e618c539c400139dd43d90e02
  depends_on "tre"

  uses_from_macos "unzip" => :build
  uses_from_macos "ncurses"

  on_linux do
    depends_on "acl"
  end

  def install
    odie 'Switch to `depends_on "lua"`!' if build.stable? && version > "0.9"

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
