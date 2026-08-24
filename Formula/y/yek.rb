class Yek < Formula
  desc "Fast Rust based tool to serialize text-based files for LLM consumption"
  homepage "https://github.com/mohsen1/yek"
  url "https://github.com/mohsen1/yek/archive/refs/tags/v0.25.5.tar.gz"
  sha256 "e74cdfc577bdfb6577324afc086546ff306c7c43053f526e7ae30031c4433ab4"
  license "MIT"
  head "https://github.com/mohsen1/yek.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9586588ae2852e2affef7e90f638a0286c2d12a99fa6954a0ac54e8c828f8e21"
    sha256 cellar: :any, arm64_sequoia: "ea3206eea01170abc93eadb1cf006c9c6352084e5ac0ba33dbc10c7be410f040"
    sha256 cellar: :any, arm64_sonoma:  "bbf81c18dbf3db911ca81c6aa8ea579dfd255ac34b85ed976e990a38d26714f6"
    sha256 cellar: :any, sonoma:        "83529651f3e1033f8bd1aa1454ea2f745680c158c0f87ff5d82c725fd5dfad28"
    sha256 cellar: :any, arm64_linux:   "9a13a14899b745a629600b1a9d89bed5eb7966989ae06ead7680cf954a3a65de"
    sha256 cellar: :any, x86_64_linux:  "00fd5a8a7e3a95196732699ff4ce771f58b91086514b20868a0bc6944a82af93"
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
