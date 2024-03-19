class Sngrep < Formula
  desc "Command-line tool for displaying SIP calls message flows"
  homepage "https://github.com/irontec/sngrep"
  url "https://github.com/irontec/sngrep/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "045189f411cffba5083ad917f77fb5c717470b7d4f8f2604880a8ef68aa656b5"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "562e32438e4fb3affe1f86cccdde69b13f42271ea867cf9dacb6573cddaadd82"
    sha256 cellar: :any,                 arm64_ventura:  "46fc0a675b34ffd34e3bd44b660adc7321b9c8c7770d41d28e868b3f2b2de526"
    sha256 cellar: :any,                 arm64_monterey: "dd3093a8dfea2d4659e69ede2832a19b75ef4f6af793e592982fd1bf651b6b6f"
    sha256                               sonoma:         "8dc4048c10595d25325b151833d39820b7b73ac9ad48da31bdb912bbcba135a1"
    sha256                               ventura:        "119aaa318e2d4ce9ed98b96e2850de5ce09aed8ffda3afd531962992e7fdde57"
    sha256                               monterey:       "7be0969b7f0d1afe6e4b328bc9aee98ff49c6c7c272d020cd0bfa86551b3b314"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f4f6e925c8485b5bdc025b016be82cdc45924292d67477fa55e13e87df7a0da"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "ncurses" if DevelopmentTools.clang_build_version >= 1000
  depends_on "openssl@3"

  uses_from_macos "libpcap"
  uses_from_macos "ncurses"

  def install
    ENV.append_to_cflags "-I#{Formula["ncurses"].opt_include}/ncursesw" if OS.linux?

    system "./bootstrap.sh"
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--with-openssl"
    system "make", "install"
  end

  test do
    system bin/"sngrep", "-NI", test_fixtures("test.pcap")
  end
end
