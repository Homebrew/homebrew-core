class RedwaxTool < Formula
  desc "Universal certificate conversion tool"
  homepage "https://redwax.eu/rt/"
  url "https://redwax.eu/dist/rt/redwax-tool-1.0.0.tar.bz2"
  sha256 "dd2d7e6ce1ee9b78bc3a2d076f4c1b282b61e9a3a20456566d3e62d32dc12d5e"
  license "Apache-2.0"
  revision 1

  livecheck do
    url "https://redwax.eu/dist/rt/"
    regex(/href=.*?redwax-tool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "2529ee7f15ecdd3248f57f4addc086c0afdef2de61f44d23a636dbbe48d95988"
    sha256 arm64_sequoia: "2c481f5c7870e761dba5cfe94df7f63a31913858d39c53e55c3fa1e2e6435834"
    sha256 arm64_sonoma:  "f68f532e621df9d89c65efe94f66c528e937910ce6af06fa7238236a7c17cbde"
    sha256 sonoma:        "ce9b67daccd66bab249daf0a50039171ee3cfc2c2471520c2e7a0768ce5bdd78"
    sha256 arm64_linux:   "936d3d2007956b068d9d0ada00d9c68a09de5b936912dc58fc68bd7aa4a9c186"
    sha256 x86_64_linux:  "135cde0d7a1d503d9e760b1a87a71955ca335b53871c874da0854a2b5647e3c7"
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
           "-subj", "/#{x509_args.map { |key, value| "#{key}=#{value}" }.join("/")}"

    args = %w[
      --pem-in key.pem
      --pem-in cert.pem
      --filter passthrough
      --pem-out combined.pem
    ]

    expected_outputs = [
      "pem-in: private key: OpenSSL RSA implementation",
      "pem-out: private key: OpenSSL RSA implementation",
      "pem-in: intermediate: #{x509_args.map { |key, value| "#{key}=#{value}" }.reverse.join(",")}",
      "pem-out: intermediate: #{x509_args.map { |key, value| "#{key}=#{value}" }.reverse.join(",")}",
    ]

    output = shell_output("#{bin}/redwax-tool #{args.join(" ")} 2>&1")

    expected_outputs.each do |s|
      assert_match s, output
    end

    assert_path_exists testpath/"combined.pem"
  end
end
