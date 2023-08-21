class Sh4d0wup < Formula
  desc "Signing-key abuse and update exploitation framework"
  homepage "https://github.com/kpcyrd/sh4d0wup"
  url "https://github.com/kpcyrd/sh4d0wup/archive/v0.9.0.tar.gz"
  sha256 "ec6aa007417e76338bc903d969e88f038ba982eb603f227f85caea5b8ad715c3"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "625ff1831dd74f6c363af58e947abe676698b3bdc8bcfde737bc98d97f1425e8"
    sha256 cellar: :any,                 arm64_monterey: "5151c364135e7352f65ec4fa83f6aee4cc7a68692d439cbf1ef99228edffb2e6"
    sha256 cellar: :any,                 arm64_big_sur:  "968a6376b01399c0b866a6993399236ce9388e6e27edf8906ae8bb31d31632c1"
    sha256 cellar: :any,                 ventura:        "8ccc23105a48b12adc77df6c21da9784f3126a4593e461b5e9917dc09a72567b"
    sha256 cellar: :any,                 monterey:       "ee4c5964a3380280f9354764b5e0637d591e2cc821fdc97493a4439d264e5e2c"
    sha256 cellar: :any,                 big_sur:        "3314e6a51d3eb84fbbf0e5db0be16769cbd2000487af1e7c685cd3e6942839d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0373bf97b519aa3acbd7e3eb987bea9209a3d7f13675664cac467b8ce80d47d2"
  end

  depends_on "llvm@15" => :build # for libclang
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "pgpdump" => :test
  depends_on "nettle"
  depends_on "openssl@3"
  depends_on "pcsc-lite"
  depends_on "zstd"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"sh4d0wup", "completions")
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    output = shell_output("#{bin}/sh4d0wup keygen tls example.com | openssl x509 -text -noout")
    assert_match("DNS:example.com", output)

    output = shell_output("#{bin}/sh4d0wup keygen pgp | pgpdump")
    assert_match("New: Public Key Packet", output)

    output = shell_output("#{bin}/sh4d0wup keygen ssh --type=ed25519 --bits=256 | ssh-keygen -lf -")
    assert_match("no comment (ED25519)", output)

    output = shell_output("#{bin}/sh4d0wup keygen openssl --secp256k1 | openssl ec -text -noout")
    assert_match("ASN1 OID: secp256k1", output)

    [
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"sh4d0wup", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
