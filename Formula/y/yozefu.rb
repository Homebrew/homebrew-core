class Yozefu < Formula
  desc "TUI for exploring data in a Kafka cluster"
  homepage "https://github.com/MAIF/yozefu"
  url "https://github.com/MAIF/yozefu/archive/refs/tags/v0.0.10.tar.gz"
  sha256 "c3053428ad866de6afc930f77260f96023906d496ef6acb9f70bd1fe2a25b2ce"
  license "Apache-2.0"
  head "https://github.com/MAIF/yozefu.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fc717462ccce575ec562056e16cca27fb817d6969615686f4fdaad40b719c3a4"
    sha256 cellar: :any,                 arm64_sonoma:  "210c643f2f0a543b400c0c9261fccf23a7a7942812ebba562bf1befee72dfbb5"
    sha256 cellar: :any,                 arm64_ventura: "1145c163a5d6b89365e06512f96ac2dce1a496640023f5af88c15b4f9fbe1690"
    sha256 cellar: :any,                 sonoma:        "faff7f463cab86e79e8e2f657640165301a10f27c7524b1d715a8db515c8c2bc"
    sha256 cellar: :any,                 ventura:       "9d85b0066ccd4b3674b63d11825f3ef45e427b1d7d7722c5f44fe52d97845f0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "caaafe270f4dc06ec01789c9961d5263c5d2315f20d4daa422c22ae0950657a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8841a48a34ebf180ed3bf63a799a38ab831e10aa39a93cc2ee077550a750259d"
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
