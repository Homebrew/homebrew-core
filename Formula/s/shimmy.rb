class Shimmy < Formula
  desc "Small local inference server with OpenAI-compatible GGUF endpoints"
  homepage "https://github.com/Michael-A-Kuykendall/shimmy"
  url "https://github.com/Michael-A-Kuykendall/shimmy/archive/refs/tags/v2.6.4.tar.gz"
  sha256 "9d9b410898618cbcfe3bf171c4d75d5d6542ebe08fb73e20d4115ad99e3b10ab"
  license "Apache-2.0"
  head "https://github.com/Michael-A-Kuykendall/shimmy.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3c155843efa62f6a3726db7033cefbff5a3140639d3a07bc08bbcef609862b92"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ef267a4024ee28e9841beddadada13cfee8a019aeb28acfcf3ef27cf231aee59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5cea431bd6ab40a5299724f7d0fa70b603294abcb18e0575e7f38714ff58bcde"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "f5c982253ba6040bc031a3d6d1be6d2a1c411fad0328386c4a061427882c903b"
    sha256 cellar: :any,                 arm64_linux:       "63d45684d4d306a29fa226624c1b8f0ebbec34cc6f956f2b31abaf6cadb2a9db"
    sha256 cellar: :any,                 x86_64_linux:      "3bd460d722e2518f666d53160a66809d09d39af1f9081329179d651d989948c3"
  end

  depends_on "cmake" => :build # for llama-cpp-sys-2
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang

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
    resource "test-gguf" do
      url "https://huggingface.co/ChristianAzinn/gte-small-gguf/resolve/main/gte-small.Q2_K.gguf?download=true"
      sha256 "71bc9beaecd0a3c5f075b8959f84c4cdf6c27dbc39930b0ab4d7c443b9373bc6"
    end

    assert_match version.to_s, shell_output("#{bin}/shimmy --version")

    resource("test-gguf").stage testpath/"models"
    output = shell_output("#{bin}/shimmy list")
    assert_match "Total available models: 1", output
  end
end
