class Shimmy < Formula
  desc "Small local inference server with OpenAI-compatible GGUF endpoints"
  homepage "https://github.com/Michael-A-Kuykendall/shimmy"
  url "https://github.com/Michael-A-Kuykendall/shimmy/archive/refs/tags/v2.6.7.tar.gz"
  sha256 "fcc272f4acb93e0c04c693082212f58ea278c007fb58730b7cc95e5813636de3"
  license "Apache-2.0"
  head "https://github.com/Michael-A-Kuykendall/shimmy.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ec5b295c60402a97b6a8a44300d2cf6a88a62690d3228a520caa69e0a1abd6c7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7e3bc9bc88e94a130cdcb55a3c633fe649f286c0d10648a9c045207e1266f0d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2db9d5e500e516e34e3ee4bdf13f5fe60204a2f09e16d1c2cf91d6372b8628e3"
    sha256 cellar: :any,                 arm64_linux:       "a16b48800e08e268e73b605ec62e881e912281c9a0ea2abfa3ae22e27c0704c0"
    sha256 cellar: :any,                 x86_64_linux:      "ac461709da7db6535043230c2a41903dd923bdba47f5ea273a592fc7fee082b3"
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
