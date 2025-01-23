class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://github.com/mozilla/sccache/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "150967a59f148f780acc167c9e35961a196953bd804d513ab013344d73deb436"
  license "Apache-2.0"
  head "https://github.com/mozilla/sccache.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aac770af6ee00a27877153f8e15a24ffc0b91fff5eb57fb6132a1a1e1c5c40b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f292ba31b0b75abf059d48e5e804e5cf8ddf99fdb825769440c37d7cffba1c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "65c4cc824f22b26e1cafc59640905fe49bcc217393932080d275bd8f403d81f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "aed415b326a1b0270be08d03496e68decda4e881c8e2152ea2c917115a57ee3e"
    sha256 cellar: :any_skip_relocation, ventura:       "48b1b2c2b3c3ad11bc5986900f43ef5fe5de5f911c83d718d2a4bd9ea407139a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e4a6a0d1cf6a76292c22ba5e513f5f339084463941c04ac14aa88ddc1ac6f47"
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
    (testpath/"hello.c").write <<~C
      #include <stdio.h>
      int main() {
        puts("Hello, world!");
        return 0;
      }
    C
    system bin/"sccache", "cc", "hello.c", "-o", "hello-c"
    assert_equal "Hello, world!", shell_output("./hello-c").chomp
  end
end
