class RvR < Formula
  desc "Declarative R package manager"
  homepage "https://a2-ai.github.io/rv-docs/"
  url "https://github.com/A2-ai/rv/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "d223340a8f6374a4a1755dc54aabb06ea7603ca397b883f118314f2fe7eb5015"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60494ce643edbb8683f179edf1b1dd241943cabb5831e823cad017f4b3e89e88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80688f3202fd5c6433dd5fa84781e7dd11b8bf5c71dd2e8233303fc7c79d28f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b65ec0d76093b0270569994c014e42fb2dace00e7be87aa0c476d5819466a27"
    sha256 cellar: :any_skip_relocation, sonoma:        "4452e7305b2a57e5655c0ea2965096d87195e7c4e54879e0653120b3da44dd7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9826dbd36d5eabf8cd88a1d746e1c06e8b58d6e8a27a553e6f32c06e8bdea205"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0d6c6d7d000d6e2fc1d39b378ff64d00ede41085fa92bd5613306c09186176e"
  end

  depends_on "rust" => :build
  depends_on "r" => :test

  conflicts_with "rv", because: "both install `rv` binary"

  def install
    system "cargo", "install", "--features", "cli", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rv --version")
    system bin/"rv", "init"
    assert_path_exists "rproject.toml"
  end
end
