class RedwaxTool < Formula
  desc "Universal certificate conversion tool"
  homepage "https://redwax.eu/rt/"
  url "https://redwax.eu/dist/rt/redwax-tool-1.0.0.tar.bz2"
  sha256 "dd2d7e6ce1ee9b78bc3a2d076f4c1b282b61e9a3a20456566d3e62d32dc12d5e"
  license "Apache-2.0"

  livecheck do
    url "https://redwax.eu/dist/rt/"
    regex(/href=.*?redwax-tool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "df4ddf01024dfde7043791c8c816cee438fbd91d6ce6bd4c952e32932f139466"
    sha256 arm64_sequoia: "18943e0545f824c95a02107eb5e2d3113921a4dec7f70e38b0a9c99360838b30"
    sha256 arm64_sonoma:  "4f7ba708291d0a8d55dc60dafaccf9e25c30ed7f69460175937769edee510cbf"
    sha256 arm64_ventura: "636f7fb81a83351e5663edd8a9f55bfcf6da9468e99c294ba718c1682183ffe0"
    sha256 sonoma:        "aeace3d70b6856d3b41435e67e8841db8932ecc98f77dcef6171a8d414abe356"
    sha256 ventura:       "a1b39030dca8dc36b515a668d391b9ca661e0308163fe722069714553ba5dc98"
    sha256 arm64_linux:   "68957ca0352be57c3439fbd84d584a080729c17472e5193e8fd836c261d5a65e"
    sha256 x86_64_linux:  "10ad5632233a8a26fa7561d2cc0d7059c2cfee757c20d8b934b761ce242fde9d"
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
