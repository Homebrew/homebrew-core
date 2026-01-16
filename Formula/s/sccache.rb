class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://github.com/mozilla/sccache/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "cc93c603b938f7444c180c049ce9d983e6b08eb2a0d44973b4794508589f891c"
  license "Apache-2.0"
  head "https://github.com/mozilla/sccache.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77c6dff5a6394ff3a752f83c1f0b7ad058e66601197c2619520f64be97933dcc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d53ec259dc13203bb1a57ad40cf5a6859a67fc6655f5568f713e376efe74eba6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7671323653004a358ee5b9aa8b648c08dc58cccfae112e1aa22975755ec76a8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec13e02a1411e9a666158e34c4905e4aa9079e4a7d7f25e9b3f8fa117b713401"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f2e8c3166765b62543c374b673bb8a4d161b7c0f0c04cf655ff252d59a8a496"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eff70597ce6173dd9aa7cbeb028aa8a1e3ac37e4069b3277d4afb446e9409bde"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
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
