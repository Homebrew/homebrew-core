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
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "6fcf250b11638459e68b989b76165c74d94d261e9a6edd4832f825b32ba31548"
    sha256 cellar: :any, arm64_tahoe:       "7f1277d480988802856ba9e76836116096454fac31bef4004dd955e2a5a8d451"
    sha256 cellar: :any, arm64_sequoia:     "52d7d4c969a389d1a9d83d3888419da4e6b972570d737b0f6d0d3c300eae61ae"
    sha256 cellar: :any, arm64_linux:       "919a7a231412e95d3c92eb581ca015deda92e94e624423ba96b84becf42694b3"
    sha256 cellar: :any, x86_64_linux:      "9e8787a06408825a5086419e44784359cbe6d31a1111c3d3170c087366ffe809"
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
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")

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
