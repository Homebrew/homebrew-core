class Wget < Formula
  desc "Internet file retriever"
  homepage "https://www.gnu.org/software/wget/"
  license "GPL-3.0-or-later"
  revision 2
  compatibility_version 1

  stable do
    url "https://ftpmirror.gnu.org/wget/wget-1.25.0.tar.gz"
    mirror "https://ftp.gnu.org/gnu/wget/wget-1.25.0.tar.gz"
    sha256 "766e48423e79359ea31e41db9e5c289675947a7fcf2efdcedb726ac9d0da3784"

    # Backport support for OpenSSL 4
    patch do
      url "https://gitlab.com/gnuwget/wget/-/commit/aaec8d52a06c46eeab570b8ef3e10760ebc66b7a.diff"
      sha256 "96aa2923ce9a12dbc2c82969705da4f72792816b087dbee19c04cd2cb2769ea8"
      type :backport
    end
  end

  bottle do
    sha256 arm64_golden_gate: "d89ea78fbc8ec79a80d52c7dcaa28e50c2bb435acd1470ee2cae4ef7646eff7e"
    sha256 arm64_tahoe:       "38024004cafd418d1ce2e2cd6b11ecf8a5e6a24d2641ba624dd016bb650d2240"
    sha256 arm64_sequoia:     "899cfc98a094aa22f54d7b46762f2e9529dfa621bc2103d2612747ad251c633c"
    sha256 arm64_linux:       "ba2ac22093f8e594a55574c7bf86a488dfe0a539faf5370d20fab3a3872d4254"
    sha256 x86_64_linux:      "32d971ac2d28eb31c50812004d459c597fbdd6691db82129e244b5e80c06f952"
  end

  head do
    url "https://git.savannah.gnu.org/git/wget.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "xz" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "libidn2"
  depends_on "libpsl"
  depends_on "openssl@4"

  on_macos do
    depends_on "gettext"
    depends_on "libunistring"
  end

  on_linux do
    depends_on "util-linux"
    depends_on "zlib-ng-compat"
  end

  # Test downloads from the network
  allow_network_access! :test

  def install
    system "./bootstrap", "--skip-po" if build.head?
    system "./configure", "--sysconfdir=#{etc}",
                          "--with-ssl=openssl",
                          "--with-libssl-prefix=#{formula_opt_prefix("openssl@4")}",
                          "--disable-pcre",
                          "--disable-pcre2",
                          "--with-libpsl",
                          "--without-included-regex",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"wget", "-O", File::NULL, "https://google.com"

    # Verify PSL support is built in via libpsl
    assert_match "+psl", shell_output("#{bin}/wget --version")
  end
end
