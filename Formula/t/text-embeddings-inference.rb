class TextEmbeddingsInference < Formula
  desc "Blazing fast inference solution for text embeddings models"
  homepage "https://huggingface.co/docs/text-embeddings-inference/quick_tour"
  url "https://github.com/huggingface/text-embeddings-inference/archive/refs/tags/v1.9.4.tar.gz"
  sha256 "9bf7d4f4f149d8bea453a5783803d1db7949d79316f95b1cdf85d1842e8d0380"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9c3675efe828bfea3923b9f03da240ad9f242115930d272e4334107252dafca9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "43588f288a133c9147ebffbdb0a6b8f630ca2653fd5f002757ed6c99839c2d18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1a25a69f9536564a236ec9f1e1d0d3ae438de36b8297e60a2307778315957ffb"
    sha256 cellar: :any,                 arm64_linux:       "b3aaa3d02771808fa93c6038859146a61e4f96a27ddc50508151cf9337d3b1aa"
    sha256 cellar: :any,                 x86_64_linux:      "898c31b43c95d845d2ac00aad83b2889d65f28fa1d94eae5760b6d032da84c97"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    args = (OS.mac? && Hardware::CPU.arm?) ? ["-F", "metal"] : []
    system "cargo", "install", *std_cargo_args(path: "router"), "-F", "candle", *args
  end

  test do
    port = free_port
    spawn bin/"text-embeddings-router", "-p", port.to_s, "--model-id", "sentence-transformers/all-MiniLM-L6-v2"

    data = '{"inputs":"What is Deep Learning?"}'
    header = "Content-Type: application/json"
    retries = "--retry 5 --retry-connrefused"
    assert_match "[[", shell_output("curl 127.0.0.1:#{port}/embed -X POST -d '#{data}' -H '#{header}' #{retries}")
  end
end
