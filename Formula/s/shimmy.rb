class Shimmy < Formula
  desc "Small local inference server with OpenAI-compatible GGUF endpoints"
  homepage "https://github.com/Michael-A-Kuykendall/shimmy"
  url "https://github.com/Michael-A-Kuykendall/shimmy/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "e5363e358c25aa32a1a834539364a5822da4104f2005f69c8426ed249dac8943"
  license "Apache-2.0"
  head "https://github.com/Michael-A-Kuykendall/shimmy.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2bb1d3e0d98c02b2d1479381860ee33564423b1f8089c553347f223207a44dc6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "549f4a56bbbfa32aa0a78388ae37bef5bf99a5036e385fbdd81e9a6b33243053"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19c58520a3d0605be4969024707fa291560c96ec021f10e34930fae9d4748e0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "adf516e7599dff9712a51e7a88216b0e195fbb419ea69bb501ac406a9f7c6a45"
    sha256 cellar: :any,                 arm64_linux:   "5b85b1474a6dd81e560b5b7e09ee4e86c1325a1934c3b96bcbd896a098faa808"
    sha256 cellar: :any,                 x86_64_linux:  "a203e70bf69587f17ae18921ce62ad82b586144dfaa402f6b422b2be3b07455a"
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
