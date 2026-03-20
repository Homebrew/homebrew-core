class Tracebox < Formula
  desc "Middlebox detection tool"
  homepage "https://github.com/tracebox/tracebox"
  url "https://github.com/tracebox/tracebox.git",
      tag:      "v0.4.4",
      revision: "4fc12b2e330e52d340ecd64b3a33dbc34c160390"
  license all_of: [
    "GPL-2.0-only",
    "BSD-3-Clause", # noinst/libcrafter
  ]
  revision 4
  head "https://github.com/tracebox/tracebox.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "432ecef65439685b42ec4ca64303631cf4aec005e044ef86d18cfc290df88a29"
    sha256 cellar: :any,                 arm64_sequoia: "a236c267cffde3f5e896d9796858a36440deb2c762ac165c4eb69fa7abcf5053"
    sha256 cellar: :any,                 arm64_sonoma:  "aa9c714b367961f84405b6937591d908e87224208c3e84331fa6719a0c2eacde"
    sha256 cellar: :any,                 sonoma:        "a08d814aa4b20912086878f89d5e34351be100e036b20bb23600d2525fc4c61f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a3523e55afbfb45e6019257f54cf8147ab00f3c07e4402629d85ea0059be568"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb818d5e3f42f32603ef218fe02c60ece85c29b0aab05b2cae0959f91f6f1a58"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "json-c"
  depends_on "lua"

  uses_from_macos "libpcap"

  def install
    unless OS.mac?
      ENV.cxx11 # work around error: reference to 'byte' is ambiguous
      ENV.append_to_cflags "-I#{Formula["libpcap"].opt_include}"
      ENV.append "LDFLAGS", "-L#{Formula["libpcap"].opt_lib}"
    end
    # Work around limited `libpcap` and `lua` search paths in configure.ac
    ENV.append "LIBS", "-lpcap -lm"
    ENV["LUA_INCLUDE"] = "-I#{Formula["lua"].opt_include}/lua"
    ENV["LUA_LIB"] = "-L#{Formula["lua"].opt_lib} -llua"

    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules",
                          "--with-libpcap=yes",
                          *std_configure_args
    system "make"
    system "make", "install"
  end

  def caveats
    <<~EOS
      Tracebox requires superuser privileges e.g. run with sudo.

      You should be certain that you trust any software you are executing with
      elevated privileges.
    EOS
  end

  test do
    system bin/"tracebox", "-v"
  end
end
