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
    rebuild 1
    sha256 arm64_golden_gate: "d28d84df4a447ff6b5bbf9c639aa2397f26964d4679b33e87de6f60e7339ec40"
    sha256 arm64_tahoe:       "eea04ff6d8b2b96bd5b45a44cd46ca2d43dd0e5d908a8cce4e158d1358a3a709"
    sha256 arm64_sequoia:     "3a5a410ad7d7bf75941824d2e7c2ed7fc529510d708fddb8b94e5e0a983b31a6"
    sha256 arm64_sonoma:      "685ebfdf40654de305d8b7a9253871c0437d3ba2524c226b411109c771279e20"
    sha256 arm64_linux:       "b34f0bc53cac8d035fc0ee35d0a3aa05351bfcf06a83b630161dec609a466167"
    sha256 x86_64_linux:      "a6c78ac3c5a4cce63bd380af7f08fb6bbaacf76e2780d118dfe27f92df9de66b"
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

  uses_from_macos "expat", since: :sequoia

  def install
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
