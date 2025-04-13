class RedwaxTool < Formula
  desc "Universal certificate conversion tool"
  homepage "https://redwax.eu/rt/"
  url "https://redwax.eu/dist/rt/redwax-tool-0.9.9.tar.bz2"
  sha256 "f5f8149bba0e4af190235edb6e4664d1a96016324f8a2da5dd60637e03d45630"
  license "Apache-2.0"

  livecheck do
    url "https://redwax.eu/dist/rt/"
    regex(/href=.*?redwax-tool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "34eff8a283e59a1c44b65e59c11bfb6626e54e848b441441a5ab7bc16bbc1402"
    sha256 arm64_sonoma:  "2ea52c78dc303b33b192473aaf3b3f2766acd168d2002ac5173030c0e4109838"
    sha256 arm64_ventura: "6c1582c3ddf1c69440b407e9108080dedd6f290ed7ed7e1a0ad00c4b20e04262"
    sha256 sonoma:        "a6ee226d0dd5d1344a5406c2d47f3a818586d1d30ead84b86648403b2a3acf81"
    sha256 ventura:       "07b54891be06b8e8347481b0ac8c6667f895f8fde8a64ad042af1b75c89aede8"
    sha256 arm64_linux:   "6830278ea2393b0c1459ee6f6ee2fba6d5e99d5f37582276a11346f6b39e1b1c"
    sha256 x86_64_linux:  "04dfeac846d6e6714d15df10879fd6f76950a54cc52a69e952c556bd4f3230b3"
  end

  depends_on "pkgconf" => :build
  depends_on "apr"
  depends_on "apr-util"
  depends_on "ldns"
  depends_on "libical"
  depends_on "nspr"
  depends_on "nss"
  depends_on "openssl@3"
  depends_on "p11-kit"
  depends_on "unbound"

  uses_from_macos "expat"

  def install
    # Work around superenv to avoid mixing `expat` usage in libraries across dependency tree.
    # Brew `expat` usage in Python has low impact as it isn't loaded unless pyexpat is used.
    # TODO: Consider adding a DSL for this or change how we handle Python's `expat` dependency
    if OS.mac? && MacOS.version < :sequoia
      env_vars = %w[CMAKE_PREFIX_PATH HOMEBREW_INCLUDE_PATHS HOMEBREW_LIBRARY_PATHS PATH PKG_CONFIG_PATH]
      ENV.remove env_vars, /(^|:)#{Regexp.escape(Formula["expat"].opt_prefix)}[^:]*/
      ENV.remove "HOMEBREW_DEPENDENCIES", "expat"
    end

    args = %w[
      --disable-silent-rules
      --with-openssl
      --with-nss
      --with-p11-kit
      --with-libical
      --with-ldns
      --with-unbound
    ]
    args << "--with-keychain" if OS.mac?
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    x509_args = {
      "C"            => "US",
      "ST"           => "Massachusetts",
      "L"            => "Boston",
      "O"            => "Homebrew",
      "OU"           => "Example",
      "CN"           => "User",
      "emailAddress" => "hello@example.com",
    }

    system "openssl", "req", "-x509", "-newkey", "rsa:4096", "-days", "1", "-nodes",
           "-keyout", "key.pem", "-out", "cert.pem", "-sha256",
           "-subj", "/#{(x509_args.map { |key, value| "#{key}=#{value}" }).join("/")}"

    args = %w[
      --pem-in key.pem
      --pem-in cert.pem
      --filter passthrough
      --pem-out combined.pem
    ]

    expected_outputs = [
      "pem-in: private key: OpenSSL RSA implementation",
      "pem-out: private key: OpenSSL RSA implementation",
      "pem-in: intermediate: #{(x509_args.map { |key, value| "#{key}=#{value}" }).reverse.join(",")}",
      "pem-out: intermediate: #{(x509_args.map { |key, value| "#{key}=#{value}" }).reverse.join(",")}",
    ]

    output = shell_output("#{bin}/redwax-tool #{args.join(" ")} 2>&1")

    expected_outputs.each do |s|
      assert_match s, output
    end

    assert_path_exists testpath/"combined.pem"
  end
end
