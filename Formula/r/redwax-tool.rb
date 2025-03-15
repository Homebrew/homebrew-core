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
    sha256 cellar: :any,                 arm64_sequoia: "f4bfdaf79e00c2210bfe58d5e1d8ed8ed6c8030f27f45e6489915f2d58f00e64"
    sha256 cellar: :any,                 arm64_sonoma:  "cdec549c64d66941f7dc430f8e07a250be8618d8c148c820bf9b9fdadd89bca5"
    sha256 cellar: :any,                 arm64_ventura: "fc00c0e3e33b710cc410aae1346ad44f62a970da7c28857353660ecca83300af"
    sha256 cellar: :any,                 sonoma:        "f98470864037231a2c0233be3207e3f42fe425c4f2107a8ae49b0a0d47315a04"
    sha256 cellar: :any,                 ventura:       "e14ff284ee29c52c18f0c3d7a5bc5c770d05f9a3c442e61bf814cb4874c8aabd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa1966c450f5a57151f5c0f050f0e7628d48985a2d2e1acb3cf0e819e54d2fc3"
  end

  depends_on "pkgconf" => :build
  depends_on "apr"
  depends_on "apr-util"
  depends_on "ldns"
  depends_on "libical"
  depends_on "nss"
  depends_on "openssl@3"
  depends_on "p11-kit"
  depends_on "unbound"

  uses_from_macos "expat"

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
