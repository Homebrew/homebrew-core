class Shimmy < Formula
  desc "Small local inference server with OpenAI-compatible GGUF endpoints"
  homepage "https://github.com/Michael-A-Kuykendall/shimmy"
  url "https://github.com/Michael-A-Kuykendall/shimmy/archive/refs/tags/v2.6.6.tar.gz"
  sha256 "d7afd9fc1ef6bf8a10428f0044ac0e4c0f43338757a36463ab889287651bb5e8"
  license "Apache-2.0"
  head "https://github.com/Michael-A-Kuykendall/shimmy.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8fe37cccf4c4e81d7082ce504a2aa71381b01ca9481ec79e7afd663255b212fc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "aaa18fd7bf05667d754fdffa1b9673a43006c5cafa89787c65582bc106757829"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e7ec4afedb9b224d2f9e919a72a9d7cc19308002b412fd148b339cf2407d148b"
    sha256 cellar: :any,                 arm64_linux:       "a290af9d9ba4cf52bc504777595f3029d4cb3c8f57ff77cc1c3598626ef7c9e0"
    sha256 cellar: :any,                 x86_64_linux:      "b07ff901a97e6d832b444f9c1f70841eb6dc8df09a547663fd0163eb4c21835f"
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
