class Yek < Formula
  desc "Fast Rust based tool to serialize text-based files for LLM consumption"
  homepage "https://github.com/mohsen1/yek"
  url "https://github.com/mohsen1/yek/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "1010f804ac6e535e0b626d6e4d947dde707d0d972398ab200e966c7f922378f4"
  license "MIT"
  head "https://github.com/mohsen1/yek.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "ea797923705e2f69832ccefc5a5f9d38483be29d5252262a079c2d03533d5160"
    sha256 cellar: :any, arm64_golden_gate: "6d25e43b54e733dfacd3fe1ec12cd82aa4a6a607de1ec58be23aa8c9e2adcbf7"
    sha256 cellar: :any, arm64_tahoe:       "9e22a2a0ff0e0fefd30d4c3f7e3c1c2776b763c11e8ed4c992beba350eb01eb5"
    sha256 cellar: :any, arm64_sequoia:     "9e168e801f4a5c2ed746f965ec1f08145c286c2563e4d0bd8a6ceef65c2c2ab7"
    sha256 cellar: :any, arm64_linux:       "9c863fc47070b448bb779a822bfc502a4d40890c934280f67ba5890beb896080"
    sha256 cellar: :any, x86_64_linux:      "a930f21cb19c8ccba39e24a73fc395348dc42a4f3cd81e8f47d63784584d3c31"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Support system libgit2 1.9 and OpenSSL 4.
  patch do
    url "https://github.com/prooflinedev/yek/commit/9588c24b24fbf9f1724eee598d46823fdbf222ad.patch?full_index=1"
    sha256 "c3c2b5cde9a705d686e5f0952865752c0d2899ab54379ccc3e5e558a3d6c2573"
    type :unofficial
    resolves "https://github.com/prooflinedev/yek/pull/259"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    ENV["OPENSSL_DIR"] = dep("openssl").opt_prefix

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yek --version")

    (testpath/"main.c").write <<~C
      #include <stdio.h>
      #include <stdlib.h>

      int main(void) {
        printf("%s\n", "Hello, world!");
        return EXIT_SUCCESS;
      }
    C
    expected_file = shell_output("#{bin}/yek --output-dir #{testpath}")
    assert_match ">>>> main.c", expected_file
  end
end
