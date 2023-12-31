class RedwaxTool < Formula
  desc "Universal certificate conversion tool"
  homepage "https://redwax.eu/rt/"
  url "https://redwax.eu/dist/rt/redwax-tool-0.9.3.tar.bz2"
  sha256 "b431fda3e77de8570c99d5d2143a5877142a3163058591b786318a8704fb7648"
  license "Apache-2.0"

  livecheck do
    url "https://redwax.eu/dist/rt/"
    regex(/href=.*?redwax-tool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4ac1a6f0dd8dadda8eebe912a3c129638bce436884d73fbd2cf662bec6a643aa"
    sha256 cellar: :any,                 arm64_ventura:  "105c908e535de44878aa6651df14682c4a7f3f0b884f1de4d6073ae76f4ad411"
    sha256 cellar: :any,                 arm64_monterey: "c7b2ec5cd3b06fa1f8d4625935d7e97b83392babd30c40fca5dae2d3260ae91d"
    sha256 cellar: :any,                 sonoma:         "b3ca232e1f1311829f451279f9a09dcd35c307ebe806a2f9306b04d78dbd3b50"
    sha256 cellar: :any,                 ventura:        "8a3f3ad2932ff66b4a564d9de4b0f26def1797ce2bff63b545b1fe46811b2a45"
    sha256 cellar: :any,                 monterey:       "f80956a1bc088a6e361a3876e9e6eb7ff73fb734a941d2a7cd3cff59be41aac6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5a9fbeca16c8ba4008f0dd1e814b50cecdb8b5c090629fe045efed121d1707d"
  end

  depends_on "pkg-config" => :build
  depends_on "apr"
  depends_on "apr-util"
  depends_on "openssl@3"

  uses_from_macos "expat"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules", "--with-openssl"
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

    assert_predicate testpath/"combined.pem", :exist?
  end
end
