class TextEmbeddingsInference < Formula
  desc "Blazing fast inference solution for text embeddings models"
  homepage "https://huggingface.co/docs/text-embeddings-inference/quick_tour"
  url "https://github.com/huggingface/text-embeddings-inference/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "68876328e38cc1be97d6327acfa359496843f0513bcf626f8b3d6749c5818b5d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ac9966a2a6232bf3326fdee03aa20dcc803a40bcfbb566efb66149b8ed5ec88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2052d3641d11957d92b13014c63cf1633ce042e81d4684df0f3422a6ed4e614b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "efd0d073bbbee9c3064ac61d9fcdcb4676f27b5c66c95091b20b69dcbb558594"
    sha256 cellar: :any_skip_relocation, sonoma:        "666538621fef38fd6236bff4898d0f4cdba292360713cd07c2c1b201d88a8455"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1cafae0d476f91dbb5a341113dbac99b27c7bbd4efa323f6af6f1137ce1deaac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbc8913326b9a6193939c854776b3a7d655b6a52cd4d0adaafd54bc443834675"
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
