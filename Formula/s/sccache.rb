class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://github.com/mozilla/sccache/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "e78c7a65982e2ab1dc2e5580e548bb1bf6f47a0f20e58dcba8856fc97640f2d2"
  license "Apache-2.0"
  head "https://github.com/mozilla/sccache.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "784f213119a53a81aa0be9a5a9263699a4ae14f99dd81142b5a9cd61b955fa65"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d5fe8beb7c9601b5e8ff1438b53266ab104cf394448c568fa62c17d8e99ee2b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47e60c8161afd0e31876912e09afc2e72eda819cde6283e7f20178928d0be622"
    sha256 cellar: :any_skip_relocation, sonoma:         "8358f677987a05d277a115f205a86435ab5eb85883de4ae0bfc2352a4d9c9f03"
    sha256 cellar: :any_skip_relocation, ventura:        "1ee4d1e1ae6cc912788ed4406bed860cedf051d80f2730b32c70e5cde7dd2280"
    sha256 cellar: :any_skip_relocation, monterey:       "702d85599300b05ab8929a6a0847b2b37215af2ae6f31d3085f1286d7787b1fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2d94f0316e1a44ce545c8f7b6b54fae3e276f1b9dd98a5587e13906ad2a8bd4"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix if OS.linux?

    system "cargo", "install", "--features", "all", *std_cargo_args
  end

  test do
    (testpath/"hello.c").write <<~EOS
      #include <stdio.h>
      int main() {
        puts("Hello, world!");
        return 0;
      }
    EOS
    system "#{bin}/sccache", "cc", "hello.c", "-o", "hello-c"
    assert_equal "Hello, world!", shell_output("./hello-c").chomp
  end
end
