class Yozefu < Formula
  desc "TUI for exploring data in a Kafka cluster"
  homepage "https://github.com/MAIF/yozefu"
  url "https://github.com/MAIF/yozefu/archive/refs/tags/v0.0.11.tar.gz"
  sha256 "a3ea8b1311bac49110b562e00887380d153083563934e7a3e4f0db40d24797e2"
  license "Apache-2.0"
  head "https://github.com/MAIF/yozefu.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "740fb1adc0e08439cf87e92956b123b7ca912456cf153bef89145f3e2dc8ef0f"
    sha256 cellar: :any,                 arm64_sonoma:  "4794734e52f64d33f4bdf93bd5167763076ea8349a239c98ea5f3e24ebba640e"
    sha256 cellar: :any,                 arm64_ventura: "c17e22cc084fce1f87e4f9f47b4fcdafe12e13cef90d1cc1691e695f7cb15166"
    sha256 cellar: :any,                 sonoma:        "ee53201e74efeb8d7a914cce222add5a367e984c7a403a6381bcc97f60461e3d"
    sha256 cellar: :any,                 ventura:       "82226961b56b73654b133806261d62f091904b0fdea01a074809ae48c644665c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2666e3ac5d0a2995b0eefed79f8ac0314a3310bb6aa6d853148906b47967e0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "306384d4e23d160565791c9c9990a6fdac9763edcc7d3c4a4e9c6eb20fb588ea"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "llvm" => :build # for libclang

  def install
    # cmake 4 support, remove when https://github.com/fede1024/rust-rdkafka/pull/766 is released
    # upstream issue, https://github.com/MAIF/yozefu/issues/83
    ENV["CMAKE_POLICY_VERSION_MINIMUM"] = "3.5"

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
