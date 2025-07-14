class TextEmbeddingsInference < Formula
  desc "Blazing fast inference solution for text embeddings models"
  homepage "https://huggingface.co/docs/text-embeddings-inference/quick_tour"
  url "https://github.com/huggingface/text-embeddings-inference/archive/refs/tags/v1.7.4.tar.gz"
  sha256 "62840db84a37fdcfdd8061b796c045a92afaa6591147df81deb621a1dd34bbd9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "274e66c040b06d75a9dcbb85dc1d722c00aeb861fbc73ac51d5467404b39b11b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a92cd1e6c94651713b81946e03d5d49de492ab639388cc0e1c18bac96d2fa3c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "24d469041535ffe244194119cd559f66181e9686bee2db3c7a3bc6931e32947e"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ad60c4dc1ef3f1491f6fb36df2a3957b38b44475443d8360b8c926abc121f6e"
    sha256 cellar: :any_skip_relocation, ventura:       "4243d351fd087000ca3d91692491443d7f577e44d774353bfa0380c6cee262b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38bfda949a75f2a58e05d75c78896a646c237c3fddb48d7d17c4ecab210a7af4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06f79973355e0816f90b0245673ee594cf20d5503b5ca50741791a6a79b256ad"
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
