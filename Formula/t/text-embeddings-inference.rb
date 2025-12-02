class TextEmbeddingsInference < Formula
  desc "Blazing fast inference solution for text embeddings models"
  homepage "https://huggingface.co/docs/text-embeddings-inference/quick_tour"
  url "https://github.com/huggingface/text-embeddings-inference/archive/refs/tags/v1.8.3.tar.gz"
  sha256 "778fcfbc98d12dd8d3a47b3a670a3a9fcb245385721f5095f36e31515d44bf7d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "832f809af4b7b37398bca2edc0545e3aab38149bb22a676a027f92d2c2759f60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd59feeb6cb0b596f93faaae2b64e9454accb2132d0092f195020c1084619f92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "504bab41dca62d5f855646504a8bbc21b7439d7158abff4040b23c9889b1c2b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "997936782ae78f1bd10abc7ae3fd2ddfdccaf8f135be3a533c659bd1ad69392e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "229d24b337d84a46750fc79d42aa9d5429521310a37a671b1874fa813f792c61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f9636dff12382578075cc7b31d2ca5c153bcf9e095e63ff93c02d98dba0e731"
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
