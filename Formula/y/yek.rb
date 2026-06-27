class Yek < Formula
  desc "Fast Rust based tool to serialize text-based files for LLM consumption"
  homepage "https://github.com/mohsen1/yek"
  url "https://github.com/mohsen1/yek/archive/refs/tags/v0.25.4.tar.gz"
  sha256 "337e126814f745c6ec5d948d7aec33bd1d42066e764e17b6482679f77927e102"
  license "MIT"
  head "https://github.com/mohsen1/yek.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "59107fb3fed6bb1932d97063fdf0947d93e627226c67b3466d2217a3118ae1e1"
    sha256 cellar: :any, arm64_sequoia: "6b7307433a733c29ab866e3f6935daf3e49dfb650da6df3819e431097ed30873"
    sha256 cellar: :any, arm64_sonoma:  "52a480c9d5c26edb14c98b2cd3ef159b9012e8ad86feab593be35e48c00ec9c4"
    sha256 cellar: :any, sonoma:        "1d2a61cef60b1cc3a104004b9b312e24eb0b967666c71867969c14c6c690d6eb"
    sha256 cellar: :any, arm64_linux:   "4539e527afb3f67939b87abf6f50a20de4c54092786f7ee26c1d30f34e764a89"
    sha256 cellar: :any, x86_64_linux:  "b30777bfc5feafdaab3802bf5de4a4e3611c83ca4a5e7d8e2bbb11a33cbf2e18"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

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
