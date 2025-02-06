class Yozefu < Formula
  desc "TUI for exploring data in a Kafka cluster"
  homepage "https://github.com/MAIF/yozefu"
  url "https://github.com/MAIF/yozefu/archive/refs/tags/v0.0.6.tar.gz"
  sha256 "9621c609db486930d766f1498bfd524adbc69a8da44780c510fda0870305c83e"
  license "Apache-2.0"
  head "https://github.com/MAIF/yozefu.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bd70440d483d1daffbba6836e2f12b78da2458f38a0e84aa5f97d9d8ab5e0647"
    sha256 cellar: :any,                 arm64_sonoma:  "d5c51db393d7c7009334a8b4b3e601350cc83f5d2b20f323490e2fc1ac96a894"
    sha256 cellar: :any,                 arm64_ventura: "394a8889d2e3843db04e1b79434569075412386e990115e5734ee60162d270e7"
    sha256 cellar: :any,                 sonoma:        "73eeac3aadb80f2016030ba835aec3862b0f1e0aaf5b72215bf20391a406c229"
    sha256 cellar: :any,                 ventura:       "789a7b1929d32a0ea5c874726332e3173a59646a82444934319821895d964e6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c63e0c800c9ff53ac6aa96621869fceb8a492af4b88f714e347e0856e54648f"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

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
