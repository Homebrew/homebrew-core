class Yozefu < Formula
  desc "TUI for exploring data in a Kafka cluster"
  homepage "https://github.com/MAIF/yozefu"
  url "https://github.com/MAIF/yozefu/archive/refs/tags/v0.0.4.tar.gz"
  sha256 "f0ac75cb1115f27d8477a1c24a50b0a5760700d6a1c7d9dc356bb894ab33d67d"
  license "Apache-2.0"
  head "https://github.com/MAIF/yozefu.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0b87611e303f9a73af1bfb6bab00b9328afd6d015af610fed147c48746bfdf2c"
    sha256 cellar: :any,                 arm64_sonoma:  "b54b3ac4c0c1c0866e2f109d82b6186229f563576f5293bfb0577e62e507a851"
    sha256 cellar: :any,                 arm64_ventura: "c7a1bb6e5e85477fbe1bf3134468a3f2fb6fc99aac9f8bc9243d8a576bfae38c"
    sha256 cellar: :any,                 sonoma:        "f1f8ddfd2e109a8d5d6f1c8bad034c3bd6cb198bc59f5e435eecd5626883b4ec"
    sha256 cellar: :any,                 ventura:       "23623445749ae0787565f5749add78ee9c9b56ecbbc0ef2e10979f4fa58c47c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd3b2240783e13a68590b490aabb432de24fcd9901cd54d16aa3e0778ca20d7c"
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

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yozf --version")

    output = shell_output("#{bin}/yozf config get a 2>&1", 1)
    assert_match "Error: There is no 'a' property in the config file", output

    [
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"yozf", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
