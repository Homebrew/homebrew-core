class Shimmy < Formula
  desc "Small local inference server with OpenAI-compatible GGUF endpoints"
  homepage "https://github.com/Michael-A-Kuykendall/shimmy"
  url "https://github.com/Michael-A-Kuykendall/shimmy/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "211103a4acdeb02b5bc9ac3ec1fe95767a30512bdd6e6bb031510e8842e0a90f"
  license "Apache-2.0"
  head "https://github.com/Michael-A-Kuykendall/shimmy.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a923a9f6e554b2adef94782957ad1c5651a01579d5ac261335eb454f0591b3f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3a9521243ab7af33446024949717eaaad1a48f95fdf245ffb43dba654331db8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cffbe1137808d7f13cf68d51005a989ddb057143e8e5228cace8dfdfe7047ab3"
    sha256 cellar: :any_skip_relocation, sonoma:        "12833598f15fe71053aa56df26c5b3ce812facbda0e2f69be392617c01125d70"
    sha256 cellar: :any,                 arm64_linux:   "d839cbe6b00abb085f872d21744713ef4b72f6ca1f756d6ed19c75d19fc0610c"
    sha256 cellar: :any,                 x86_64_linux:  "3f8741fe8fe28a3aa5ec4b6ab34ad0cb343f652211ba3060e3f09daf52e4d5a7"
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
