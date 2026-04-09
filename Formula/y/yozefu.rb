class Yozefu < Formula
  desc "TUI for exploring data in a Kafka cluster"
  homepage "https://github.com/MAIF/yozefu"
  url "https://github.com/MAIF/yozefu/archive/refs/tags/v0.0.28.tar.gz"
  sha256 "9bc47f3b685d82f07b3aca0952be28eb69ab6f244d15371f2c9ea993c94eff7a"
  license "Apache-2.0"
  head "https://github.com/MAIF/yozefu.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "287c5238e92d03c907b1a19d6664190227e0deda55a2fcc2fa6d08beff4bdf45"
    sha256 cellar: :any,                 arm64_sequoia: "2a048bc261c1cc5240eb4c530e8580c48fbc68b78d2adbc1c8cc267c59308ff7"
    sha256 cellar: :any,                 arm64_sonoma:  "4c69469b611a34872600cbf11ca9f6369f86f88fd0795e6adc8e221d069cf46d"
    sha256 cellar: :any,                 sonoma:        "0f15e6a7b8e2402bdc0adf6144f3782e220eba04c53773de7ad23218f270dd52"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7189db2417b6f8eba4919e420ddf9fc3ece28f86dc141db959b705d16e7da33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1581b6cc36674fde2efaa720358a7781055ba0dcc9b03d2ccd2d3a5a6054512f"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "llvm" => :build # for libclang

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "crates/bin")
  end

  test do
    require "utils/linkage"

    assert_match version.to_s, shell_output("#{bin}/yozf --version")

    output = shell_output("#{bin}/yozf config get a 2>&1", 1)
    assert_match "Error: There is no 'a' property in the config file", output

    [
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"yozf", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
