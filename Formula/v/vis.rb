class Vis < Formula
  desc "Vim-like text editor"
  homepage "https://github.com/martanne/vis"
  license "ISC"
  revision 1
  head "https://github.com/martanne/vis.git", branch: "master"

  stable do
    url "https://github.com/martanne/vis/archive/refs/tags/v0.9.tar.gz"
    sha256 "bd37ffba5535e665c1e883c25ba5f4e3307569b6d392c60f3c7d5dedd2efcfca"

    # Apply Fedora patch to support Lua 5.5 until upstream has new release with
    # https://github.com/martanne/vis/commit/b8fea9bcb14ea10e618c539c400139dd43d90e02
    patch do
      url "https://src.fedoraproject.org/rpms/vis/raw/bb0fc38581783fed74ead453dc216d17fbf551e4/f/vis-0.9-lua-5.5.patch"
      sha256 "300bbabe3c149e94c5e5c64622087d40d2ce8c2f4cf2146e8f3e5a6d672fdae2"
      type :unofficial
    end
  end

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "631b8f632f72ed0eb6e054463caf75827b860ebc5687a9fd0d067a3c599c8537"
    sha256 arm64_tahoe:       "97ddde56165642945938829637059178f29af95c72a5482bb9a7272c626c61dc"
    sha256 arm64_sequoia:     "3f88d6256d0451e27a3ff8f196a8265ffeb0a3d342213a920b8241cae163f95e"
    sha256 arm64_sonoma:      "51de2810491922e24ae72da32bc1294dfe65841ee08c684d2a30d3883039a0da"
    sha256 sonoma:            "1078b13e6c05d6c896cac3243a460eab1cd4f664f98cba82edc98b37397fd10a"
    sha256 arm64_linux:       "5ae58c3cd109e0034454061cb5dcdc0424ac7dba6d9d9dbef4597728158ed035"
    sha256 x86_64_linux:      "0ae9466c15d8572690620c9db4dfb0b76445a1715217e2c9d4e4439770f92ff7"
  end

  depends_on "pkgconf" => :build
  depends_on "libtermkey"
  depends_on "lpeg"
  depends_on "lua"
  depends_on "tre"

  uses_from_macos "unzip" => :build
  uses_from_macos "ncurses"

  on_linux do
    depends_on "acl"
  end

  def install
    system "./configure", "--enable-lua", *std_configure_args
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
