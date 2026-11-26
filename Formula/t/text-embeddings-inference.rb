class TextEmbeddingsInference < Formula
  desc "Blazing fast inference solution for text embeddings models"
  homepage "https://huggingface.co/docs/text-embeddings-inference/quick_tour"
  url "https://github.com/huggingface/text-embeddings-inference/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "bc1d4708e0bcbb84e03f011ff54ad9aeed8fb353bc655638eaec8df7abccd4cb"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "3c4eed60f9e7c42d47b4facf16fa2fa6a590e97739aa9a207f1dd1c0d78def95"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7af6cd6f2d0e760beaebe9de1043c28d1c0a6d4011f64a63d734b169711e303a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cf6717a098947508e979dd6d00e79ae3667a7992539eaf471622994d13b0de52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ce110927913753d25c4061c08ae4078cfc5658db39a4733469e0aee1fbfc44c1"
    sha256 cellar: :any,                 arm64_linux:       "a7e7fe8f02b3ae29f32c699c1d068670357e53c8d52c94882889342d7b725bd8"
    sha256 cellar: :any,                 x86_64_linux:      "c954b5f8dda18b6ce626eba6b10584f3a91dbe0139b55e5d1d8d23e616507e0f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Avoid `-C target-cpu=native`, which builds non-portable bottles and breaks `ring` on unrecognised CPUs
    rm ".cargo/config.toml"

    args = if OS.mac? && Hardware::CPU.arm?
      ["-F", "metal"]
    else
      []
    end
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
