class Sh4d0wup < Formula
  desc "Signing-key abuse and update exploitation framework"
  homepage "https://github.com/kpcyrd/sh4d0wup"
  url "https://github.com/kpcyrd/sh4d0wup/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "0c801c4c0a45453e6df62c96645220f4e1aff64ceb9ec82e5683dafb79e931ba"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "97ae8bdba1fc71899f95e363f62bec053cd64b17a02371a2529a903d0978e4fd"
    sha256 cellar: :any,                 arm64_ventura:  "228da4ab9cbbabb964e6fd977eee679521b7ed2d6971e22449b07fe06f3ee4d4"
    sha256 cellar: :any,                 arm64_monterey: "c9851dd0cd2ccc4ee5272607720b7e860928cec7c30c28d26c5139f7a8cde4e5"
    sha256 cellar: :any,                 sonoma:         "a00239bc0475a01aa2b6c15b603decd2259c0161f4eb642a2de8c9014699bb08"
    sha256 cellar: :any,                 ventura:        "0cace6504a3b12478609ee678ae37e1dc0ed677b71bce062418dfff3e78557ce"
    sha256 cellar: :any,                 monterey:       "48d707d918132f2f2dd5147db89b2726abf304a273d4d6fac4025017d0c6eaf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ab461329d17ad36fe0c727e88ef3afd13e83fd2532669dbcd49843c68e0bb84"
  end

  depends_on "llvm" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "pgpdump" => :test
  depends_on "nettle"
  depends_on "openssl@3"
  depends_on "pcsc-lite"
  depends_on "zstd"

  def install
    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib if DevelopmentTools.clang_build_version >= 15

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
