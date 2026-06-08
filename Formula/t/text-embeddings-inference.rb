class TextEmbeddingsInference < Formula
  desc "Blazing fast inference solution for text embeddings models"
  homepage "https://huggingface.co/docs/text-embeddings-inference/quick_tour"
  url "https://github.com/huggingface/text-embeddings-inference/archive/refs/tags/v1.9.3.tar.gz"
  sha256 "85cbe4b18033cd8e84118841a94122a8d4e4bfeeba128c4b0f77bd30d4f1e4ea"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "882a2c6914cfa360291086c732b3317d60d125094afae0a10f29c16b878d197c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3598491762db367951dbc74957b075a53700d021b891e593e8a4a37eb7c5488"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "141c6b7d4dffc4b5b89c703fcdaf93d855d85a89e81b52abc4805f5284111971"
    sha256 cellar: :any_skip_relocation, sonoma:        "e91fe44b42fe195c9e78a832f9c39ab85c8b324a06e9ce0057de9f8150039538"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4b101ad37123e4c99697960e4880ce4f53779b6d5d30c5c079ace55c5f7c369"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b54223fcde1cc35c7328489fe2e680d00fdd81469598ce55fbd8ae3b91a4fb77"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  # Fix lifetime error for `metrics` package
  # PR ref: https://github.com/huggingface/text-embeddings-inference/pull/850
  patch do
    url "https://github.com/huggingface/text-embeddings-inference/commit/574132b3ee9ebccb63e223a35ef50e42559f5666.patch?full_index=1"
    sha256 "10438e9f9428db4fc0be52dba7fabeff7a26fd906763b6a1d182e0cb710dec2c"
  end

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
