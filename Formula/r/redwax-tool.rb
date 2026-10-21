class RedwaxTool < Formula
  desc "Universal certificate conversion tool"
  homepage "https://redwax.eu/rt/"
  url "https://redwax.eu/dist/rt/redwax-tool-1.0.0.tar.bz2"
  sha256 "dd2d7e6ce1ee9b78bc3a2d076f4c1b282b61e9a3a20456566d3e62d32dc12d5e"
  license "Apache-2.0"
  revision 2

  livecheck do
    url "https://redwax.eu/dist/rt/"
    regex(/href=.*?redwax-tool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "2dbfb18c11f58e80f03c0f09ae54005d772c981a0f6ce96836eb6a5ad1d2958c"
    sha256 arm64_tahoe:       "3c61abb87bbb843f3243dde3422e1c308c02e87b312b9c1067437ea92eb913c6"
    sha256 arm64_sequoia:     "62ac5472175c5d6f3eb0963f5b0e13c3f7d90ccd5021406b878a00968cedd500"
    sha256 arm64_linux:       "e40115dd3fe70b71081a55ce6cb40a45ffbeefd6893177c2db2d60333f884bbe"
    sha256 x86_64_linux:      "1dd6cb462eb1699469dee439c48ece85b37ab1561b6bb20da3ac14c2577509d5"
  end

  depends_on "autoconf" => :build # TODO: remove with patch
  depends_on "automake" => :build # TODO: remove with patch
  depends_on "libtool" => :build # TODO: remove with patch
  depends_on "pkgconf" => :build
  depends_on "apr"
  depends_on "apr-util"
  depends_on "ldns"
  depends_on "libical"
  depends_on "nspr"
  depends_on "nss"
  depends_on "openssl@4"
  depends_on "p11-kit"
  depends_on "unbound"

  uses_from_macos "expat", since: :sequoia

  # Apply Fedora backport of upstream commit for OpenSSL 4 support:
  # https://source.redwax.eu/projects/RT/repos/redwax-tool/commits/9fa62cc6b668ac5bca4dc529f074f70c8418ec7b
  patch do
    url "https://src.fedoraproject.org/rpms/redwax-tool/raw/b23bc4fbae2cb2f9679a933223781e913fa87ca4/f/0001-Support-OpenSSL4-by-using-opaque-function-accessors.patch"
    sha256 "f217e9ee8916be3e4c0d35f790236ae4dc3ea6db8b8533688d40fc7b718d78ea"
    type :backport
  end

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

    system "autoreconf", "--force", "--install", "--verbose"
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

    openssl = formula_opt_bin("openssl@4")/"openssl"
    system openssl, "req", "-x509", "-newkey", "rsa:4096", "-days", "1", "-nodes",
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
