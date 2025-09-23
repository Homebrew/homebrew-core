class Yek < Formula
  desc "Fast Rust based tool to serialize text-based files for LLM consumption"
  homepage "https://github.com/bodo-run/yek"
  url "https://github.com/bodo-run/yek/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "6930ec4ca31a32e946b66e0b9db8afc46c8257b8b5b66fca2227b999a2262215"
  license "MIT"
  head "https://github.com/bodo-run/yek.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e006c917c04a407a68291897e3bd171be3e5e2bb6f35439982b2378fe69fbe4e"
    sha256 cellar: :any,                 arm64_sequoia: "0211d67697e9d905c88447d7795d2ebb0d4b0b5ad7ce558ef163f9b3ba7e02b2"
    sha256 cellar: :any,                 arm64_sonoma:  "2d4ce747874f7e5640a80644e9c2ff2e2eccb04e6153f7424a531091d57bae29"
    sha256 cellar: :any,                 sonoma:        "6a7f18faa8c9cc230c9c533da988ade923282b80ada2e0ed5e9908add8b48af2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9ea348b33d0839ae195e56100bfb9b3d8fe78688d06ba163b8cda7b23e0f88b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b45925f801663c82780e13876bfeaa81474053f5d4570d3abcac24171c1d19d4"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "openssl@3"
  uses_from_macos "zlib"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

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
