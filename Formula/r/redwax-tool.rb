class RedwaxTool < Formula
  desc "Universal certificate conversion tool"
  homepage "https://redwax.eu/rt/"
  url "https://redwax.eu/dist/rt/redwax-tool-0.9.7.tar.bz2"
  sha256 "00d621f710ebe27c198db2bc24e913710cdc4a0e4e09058dfa9ac9100c995870"
  license "Apache-2.0"

  livecheck do
    url "https://redwax.eu/dist/rt/"
    regex(/href=.*?redwax-tool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "47d5145608c4bd4e53812fc5d0b45ed02227c40609005ec7b115ef6642e50908"
    sha256 cellar: :any,                 arm64_sonoma:  "cf0a50409754ea19a9898eb84668506f590ffe9090013b406a13c293730b770b"
    sha256 cellar: :any,                 arm64_ventura: "1167634d79dd458d7df607c2730f89e48ea4510328ad4ba91907a97b26eb5b7b"
    sha256 cellar: :any,                 sonoma:        "b173bde7a53dee2054f6d55119086129b10b89c9189e70a35ec7a3ad2cceacd6"
    sha256 cellar: :any,                 ventura:       "b267e0c5a584638ccd4f219632dfe7b51af105ef9ebdf81bb79595c2e5acd876"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5160a7ca964a6de120991d21f1ebef91232556504ebfee44daed45924fb6b2dd"
  end

  depends_on "pkgconf" => :build
  depends_on "apr"
  depends_on "apr-util"
  depends_on "openssl@3"

  uses_from_macos "expat"

  def install
    system "./configure", "--disable-silent-rules", "--with-openssl", *std_configure_args
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
