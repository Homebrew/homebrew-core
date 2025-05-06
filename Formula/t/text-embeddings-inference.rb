class TextEmbeddingsInference < Formula
  desc "Blazing fast inference solution for text embeddings models"
  homepage "https://huggingface.co/docs/text-embeddings-inference/quick_tour"
  url "https://github.com/huggingface/text-embeddings-inference/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "f8aa773a15e15bbbd4b793aa79fe65c16bc50c52e7aa710690a7a312c69d159c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b31c7b07243ae9eac43a5720ea5a0c943478130a6774b2ab37dd9433607878cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac1df833c4b595c2306fbd150c94d7471f3c462bd22937e8558834e11ff76a2b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3cfff674ba4adc56cb746ef985e6ccd173d0b84b1c0774ce313ad6971dcf84e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d328ee1717b4c6b3779a2e372fa92385e1513154b97eb91741e4b5206f1bc25"
    sha256 cellar: :any_skip_relocation, ventura:       "d620ccac5d7b693d860e249e705d5e21dd044b45c42309f8cff5b31c2515a696"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c452f485510827673e684f809e9faad64298b823ec87860c0b5c9cbc6adc26d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe08f0101ab2c50c64e636f04546339bc95392522fe569676c7fa4b4ff5d80f6"
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
    fork do
      exec bin/"text-embeddings-router", "-p", port.to_s, "--model-id", "sentence-transformers/all-MiniLM-L6-v2"
    end

    data = "{\"inputs\":\"What is Deep Learning?\"}"
    header = "Content-Type: application/json"
    retries = "--retry 5 --retry-connrefused"
    assert_match "[[", shell_output("curl 127.0.0.1:#{port}/embed -X POST -d '#{data}' -H '#{header}' #{retries}")
  end
end
