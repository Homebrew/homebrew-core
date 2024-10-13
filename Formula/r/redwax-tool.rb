class RedwaxTool < Formula
  desc "Universal certificate conversion tool"
  homepage "https://redwax.eu/rt/"
  url "https://redwax.eu/dist/rt/redwax-tool-0.9.4.tar.bz2"
  sha256 "ebaa0cc83130b423b689197d0b890eb09af83c29e6dfbd983c34c68e99f6883f"
  license "Apache-2.0"

  livecheck do
    url "https://redwax.eu/dist/rt/"
    regex(/href=.*?redwax-tool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "8b0971fe2ff49ae26fc853202920ecaa633f5512352b1127da457087b6e7559a"
    sha256 cellar: :any,                 arm64_sonoma:   "7c0cbe89dac3c1b0f7ebf39a437453b374524835836a56fc6439e7ea6b4f7f82"
    sha256 cellar: :any,                 arm64_ventura:  "72fa28659675b26f3b9bed25274a49616ea13d44d0f2434f7b8af67cbe2ceae8"
    sha256 cellar: :any,                 arm64_monterey: "f49ac977fb00a25483f510c8ff21cb0b49700f3f0f931019d6b697a5cafa52e4"
    sha256 cellar: :any,                 sonoma:         "d801bcfab188ab87c7c7a0943fa242731c91751c1b26a0cccb34e19e88e1aac0"
    sha256 cellar: :any,                 ventura:        "bb097286cef31e3b6ede988e244c0fe4afd62f47d8debb4781090cc48015b090"
    sha256 cellar: :any,                 monterey:       "de4c817b48ab1a05d3b49d2c03f39d6762aea1a53139e31a329528f432478dff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24908bd64a1bb4c192ce7eb1fd009fd35436dc5355bc71eda539c355164da1aa"
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
