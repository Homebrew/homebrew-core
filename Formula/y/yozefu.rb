class Yozefu < Formula
  desc "TUI for exploring data in a Kafka cluster"
  homepage "https://github.com/MAIF/yozefu"
  url "https://github.com/MAIF/yozefu/archive/refs/tags/v0.0.27.tar.gz"
  sha256 "0186051ae49419672f4a218227ad5cbfcce7d0e08eb4997fe3c2db7d085247ee"
  license "Apache-2.0"
  head "https://github.com/MAIF/yozefu.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a317c77c9769cbee1149320685b0056773c98cd57325ace517e34843eba347be"
    sha256 cellar: :any,                 arm64_sequoia: "736ad4c88b7c8222c583b4f7360bbd7b68dc2736955635d6e072be5d6df01532"
    sha256 cellar: :any,                 arm64_sonoma:  "9b7415ee04f759d790b45b3a7f588d3f0238abf5b04f7e4de59b6dc0ad7c0ffb"
    sha256 cellar: :any,                 sonoma:        "38b0797eb8efdb56c4426819dece7cd957b44fd485919c4e025bcd4ffb1bd600"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1bb6ad82f251731823812036c21f373553a824ebc7af1e49caf6a026c5b48dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cb28269fcc394b5bfdaf5f4001de142c17270f313cfb1d25d522950330c4976"
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
