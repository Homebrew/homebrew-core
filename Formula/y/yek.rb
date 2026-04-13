class Yek < Formula
  desc "Fast Rust based tool to serialize text-based files for LLM consumption"
  homepage "https://github.com/mohsen1/yek"
  url "https://github.com/mohsen1/yek/archive/refs/tags/v0.25.2.tar.gz"
  sha256 "9e8dc80daafcadff586cff6d1e3f586e25cd43cd60bc7bbec1ac8b1a96a359da"
  license "MIT"
  head "https://github.com/mohsen1/yek.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "7c708d2466411a06f586155d5fcd3b2a2a8047280d82eb2f8b8475370b47dce9"
    sha256 cellar: :any,                 arm64_sequoia: "ea895a535de86d4aa18601d5334e7f26e525448f5945ffc7d2eda186caa1a2e9"
    sha256 cellar: :any,                 arm64_sonoma:  "75686e073310efef5eed37caf9b515ea48e290f8f7273ce73e3c36ec060ed823"
    sha256 cellar: :any,                 sonoma:        "50f16ea3b12bda86ae072fd28bac2bc6294868bafc92184e5639729d41b24ca5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70c00518e83711b7ba8b1a9c3f6fab4fa87f4aeb6200620bc647832715b2bb1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "482dd8f60fe32a2a7c8f3611757d343b3e7ab0e6c503683b52446a9c94c14324"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
