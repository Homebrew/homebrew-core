class TextEmbeddingsInference < Formula
  desc "Blazing fast inference solution for text embeddings models"
  homepage "https://huggingface.co/docs/text-embeddings-inference/quick_tour"
  url "https://github.com/huggingface/text-embeddings-inference/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "92c289f2ce51a9df6e69d7cf4adf17e13d7c3fb561168b74fab2be4224c38b29"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d0544b700a55278610a4f3405875107822d2b801fbb7ab5b4ca3e47f6782f9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "173d036aa4cb307a502fbb98b1436419409e94992a55e9f91052b1bf12577074"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f30e82669f79e24aefe425950543f1d8db8870aedd8c45db51c3ded78169fc3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "599e42486ac079dcfb7826fc15faa7174ba7647715e299f986181e095a1ea68d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d627908ede29b0544ebf52d3e32495106bdd9511e048a392fb2aee55591f6c61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8eb15c2cf8a11731239a3a09d1871042d40890462affc90a921ff449ff8e4037"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    args = (OS.mac? && Hardware::CPU.arm?) ? ["-F", "metal"] : []
    system "cargo", "install", *std_cargo_args(path: "router"), "-F", "candle", *args
  end

  test do
    port = free_port
    spawn bin/"text-embeddings-router", "-p", port.to_s, "--model-id", "sentence-transformers/all-MiniLM-L6-v2"

    sleep 2 if OS.mac? && Hardware::CPU.intel?

    data = "{\"inputs\":\"What is Deep Learning?\"}"
    header = "Content-Type: application/json"
    retries = "--retry 5 --retry-connrefused"
    assert_match "[[", shell_output("curl 127.0.0.1:#{port}/embed -X POST -d '#{data}' -H '#{header}' #{retries}")
  end
end
