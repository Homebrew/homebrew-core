class Yozefu < Formula
  desc "TUI for exploring data in a Kafka cluster"
  homepage "https://github.com/MAIF/yozefu"
  url "https://github.com/MAIF/yozefu/archive/refs/tags/v0.0.19.tar.gz"
  sha256 "e0938d66342524599f13e49cbe3439b7e67d67c57409b3e51b3571e6282d5a03"
  license "Apache-2.0"
  head "https://github.com/MAIF/yozefu.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b4cf4a7c87ea1a4f870f922c454072a9399917dfd78fc51a584e5931270387ee"
    sha256 cellar: :any,                 arm64_sequoia: "d5d456bedce1117efb9ab51f72bf8f8a820bd00285218d09d2c830f794496247"
    sha256 cellar: :any,                 arm64_sonoma:  "ab7450e26a535307a781451cc1e916df7f1cc0e18e0a588f2b59c29b3d9bb4da"
    sha256 cellar: :any,                 sonoma:        "f70a22d2975a7dc687e53539b2a9eea6edca7f630330db16698a3c56ccbb3365"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "131b4b2286125391d9c30dad47b630c0e9b2f6fb6ee600def20d32401b2a084b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6fc6b9f1e92421cdde0744c56a7e58491ca738d864d29da3c100279378ad8f0"
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
