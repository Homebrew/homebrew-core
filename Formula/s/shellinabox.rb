class Shellinabox < Formula
  desc "Export command-line tools to web based terminal emulator"
  homepage "https://github.com/shellinabox/shellinabox"
  url "https://github.com/shellinabox/shellinabox/archive/v2.20.tar.gz"
  sha256 "27a5ec6c3439f87aee238c47cc56e7357a6249e5ca9ed0f044f0057ef389d81e"
  license "GPL-2.0-only"
  revision 1

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d00dfd6b119c7d8555081e4ad821d67ecf0da641c5630435e67c3c9eadedd1a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b29df2258a90e8cfef9e54cf0569c1e556f07911d0dbb934e6760487416a3f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ceb68ab288df2b997e3c7361cd6e8c0fb389ee9fa187503f14e2bd5f00393f03"
    sha256 cellar: :any_skip_relocation, ventura:        "d303f6e2a79b3022f4659934635aa4c7fb4abeb18384bfafb1c012064a03018c"
    sha256 cellar: :any_skip_relocation, monterey:       "17b6552900a2b8eb5297e6db21d07479821a95cbcc3d34d0c553e47ebd2595ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "920301191fb40b3f036e5d08175f829e512f9e6df63760cdc389a12a7c01429f"
    sha256 cellar: :any_skip_relocation, catalina:       "a0d28e1679ea480a87fa8deeae9f3378f18322d6f3062d4a0f0dd71dbe5c6469"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "402a852e03ce83de0813d1775222f02e1fd4a52e13ce6757bd16a3adda0688fa"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

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
    assert_match "ShellInABox - Make command line applications available as AJAX web applications",
                 shell_output("curl -s http://localhost:#{port}")
    Process.kill "TERM", pid
  end
end
