class TextEmbeddingsInference < Formula
  desc "Blazing fast inference solution for text embeddings models"
  homepage "https://huggingface.co/docs/text-embeddings-inference/quick_tour"
  url "https://github.com/huggingface/text-embeddings-inference/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "b2c2efb245a6b308955cd4470b2cfef6c0584a840239a692896adbf7a70e86d0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f8455cc43cae70c599001cf00e603bcd22883d6943536818b2f6435e38d432f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92ea3cbcfa2bb27f55fcff8b8af03be5c91ad8a6406d1fd142e8203bd9e9c1fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86e8927ee419b2f68993caeb1769243904fc542849a7aaada9776e679c62a3d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d99c69b5b539b4e23fd5452f0e7a47f515bb5e97e52be6f3808c4f3d14d63031"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc5b0ac55e8eef6ca7d441cb7e93173a14f9b58a59e85863cf526b9f62f7bef3"
    sha256 cellar: :any_skip_relocation, ventura:       "875d6fe52f81715e514ac2b724b24831fc5ff6d3daea9b7b7077b7fd7ea7f4b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "afb2eb2c30d221514252fbff9e59417f5a7cfbcf57be41e97612c765ed948bb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "711ddc3558d9ba583494bcaf4411e8018af9dbd6d2efcdffff5b2410369e253b"
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
