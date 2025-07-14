class Yek < Formula
  desc "Fast Rust based tool to serialize text-based files for LLM consumption"
  homepage "https://github.com/bodo-run/yek"
  url "https://github.com/bodo-run/yek/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "2c0e863e0f49f690977910498a1b8dd151c625bf04b88a7d6ff20553590b6ccf"
  license "MIT"
  head "https://github.com/bodo-run/yek.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2d5276241deded5acf624a31b29ac860986c82fa12d46e3bc0dd697b86316730"
    sha256 cellar: :any,                 arm64_sonoma:  "e002487f80db2f64322b9110b33705159d36da98dba3916e832d88caf8143346"
    sha256 cellar: :any,                 arm64_ventura: "a44f0bd71899bbb2bd95d3c1cf07e72b4a511c861e7bef2a1883e572df2c0f32"
    sha256 cellar: :any,                 sonoma:        "1627a4d75dd780a1ecf0c2f756327102ef247c30b612aa931e4067684c4a97af"
    sha256 cellar: :any,                 ventura:       "1117b2d2b0d74e8c3dd4214e5dda6ced03090ccea62d54d214d376aca945fa96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cdbafc81a9301d1bd455ae773111f8cbf43715b0341e6b310e53b2b56ba5c41e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a63bf23710982ff18db2e129a2001c7447007d24ca9b30be4a26de2c0b83f16"
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
