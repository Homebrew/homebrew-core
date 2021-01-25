class Shellinabox < Formula
  desc "Export command-line tools to web based terminal emulator"
  homepage "https://github.com/shellinabox/shellinabox"
  url "https://github.com/shellinabox/shellinabox/archive/v2.20.tar.gz"
  sha256 "27a5ec6c3439f87aee238c47cc56e7357a6249e5ca9ed0f044f0057ef389d81e"
  license "GPL-2.0"
  revision 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1bce570cc372ee17dd73bcde84ba9dc8db44ad968882eb25d842be7e3300a00c" => :big_sur
    sha256 "16393025f2b7dc93d7f01c9e7a0f8f538f3be37276e75afc7d50863d552124a5" => :arm64_big_sur
    sha256 "54a87f3514eb39cbbb1c4c127127d6b3eccd69d67f7ea26c32084218cb7d7d96" => :catalina
    sha256 "364588ed44513d77da920c1dfa722b8bd6351f72b2f18f2e7ec4edcc808fe9d7" => :mojave
    sha256 "78a08258706eec184d42977bda76175e827a909389a70627f6eed67a10c78d45" => :high_sierra
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
