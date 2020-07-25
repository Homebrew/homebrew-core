class Shellinabox < Formula
  desc "Export command-line tools to web based terminal emulator"
  homepage "https://github.com/shellinabox/shellinabox"
  url "https://github.com/shellinabox/shellinabox/archive/v2.20.tar.gz"
  sha256 "27a5ec6c3439f87aee238c47cc56e7357a6249e5ca9ed0f044f0057ef389d81e"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "bbed6a113c24f9780c55d18e9fe4e487a004acbcfd4ed39dc52245164c6921bb" => :catalina
    sha256 "be4a272fb621880a3357ec3661eb9e455c965200bcaa338a07a1610a651c9f3a" => :mojave
    sha256 "941b62ffa692c9b233ed65803a4572d0012cd925971abd1e529d256566dcc05a" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@1.1"

  # Upstream (Debian) patch for OpenSSL 1.1 compatibility
  # Original patch cluster: https://github.com/shellinabox/shellinabox/pull/467
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/219cf2f/shellinabox/2.20.patch"
    sha256 "86c2567f8f4d6c3eb6c39577ad9025dbc0d797565d6e642786e284ac8b66bd39"
  end

  def install
    # Force use of native ptsname_r(), to work around a weird XCode issue on 10.13
    ENV.append_to_cflags "-DHAVE_PTSNAME_R=1" if MacOS.version == :high_sierra
    system "autoreconf", "-fiv"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    port = free_port
    pid = fork do
      system bin/"shellinaboxd", "--port=#{port}", "--disable-ssl", "--localhost-only"
    end
    sleep 1
    assert_match /ShellInABox - Make command line applications available as AJAX web applications/,
                 shell_output("curl -s http://localhost:#{port}")
    Process.kill "TERM", pid
  end
end
