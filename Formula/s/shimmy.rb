class Shimmy < Formula
  desc "Small local inference server with OpenAI-compatible GGUF endpoints"
  homepage "https://github.com/Michael-A-Kuykendall/shimmy"
  url "https://github.com/Michael-A-Kuykendall/shimmy/archive/refs/tags/v2.6.5.tar.gz"
  sha256 "1db5bad1b642bc529ef3e9c4a585be6e7e27c22da85035a8bfda69213755f465"
  license "Apache-2.0"
  head "https://github.com/Michael-A-Kuykendall/shimmy.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9b29b42769b81af2c0a7e0c5848f5171ac955779a669e9e53f4718ba8be5c044"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e154d629e4bc0b71fe8b175b092f8f6f15d0af4b42506221c512ecd08b306374"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a7e33b7e2628e9c40137b7dfeb33ad378ab1446ba65b045fa0dbf6e5f1c79358"
    sha256 cellar: :any,                 arm64_linux:       "b69916afa327967f4237b33433d4c41134b0fa972b92a706d93a2f1f24c17a9b"
    sha256 cellar: :any,                 x86_64_linux:      "baa5dfa90a05bcdeccf7be569fd5e613cf758469560bd16e4440519a292def17"
  end

  depends_on "cmake" => :build # for llama-cpp-sys-2
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang

  resource "test-gguf", :test do
    url "https://huggingface.co/ChristianAzinn/gte-small-gguf/resolve/main/gte-small.Q2_K.gguf?download=true"
    sha256 "71bc9beaecd0a3c5f075b8959f84c4cdf6c27dbc39930b0ab4d7c443b9373bc6"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"shimmy", "serve", "--bind", "127.0.0.1:11435"]
    keep_alive true
    log_path var/"log/shimmy.log"
    error_log_path var/"log/shimmy.error.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shimmy --version")

    resource("test-gguf").stage testpath/"models"
    output = shell_output("#{bin}/shimmy list")
    assert_match "Total available models: 1", output
  end
end
