class Shimmy < Formula
  desc "Small local inference server with OpenAI-compatible GGUF endpoints"
  homepage "https://github.com/Michael-A-Kuykendall/shimmy"
  url "https://github.com/Michael-A-Kuykendall/shimmy/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "5f53a33fd0204407f334769e76b53e361292251ff87a649f2feba55b16973039"
  license "Apache-2.0"
  head "https://github.com/Michael-A-Kuykendall/shimmy.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "542aaef864c44ae4b6b033e2775ca7bea89875f7003358db91e45e9f2f91175f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a932834afda1859565ffb527ea5c5b394910c0c5582457e36e34998f9f41661b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e966c9f59bd0a496edeb804b52b118139195abadd58c4c8c4bc3986eb6e7c15e"
    sha256 cellar: :any_skip_relocation, sonoma:        "382e67a240761b877a7976c9f3497f285c4438f46020a35822fc22b3da0fdef4"
    sha256 cellar: :any,                 arm64_linux:   "ba7e5f23867f4bf0a1fc82ac22b7c294bc51dca0f2966513dfae7fa3dbcbb31d"
    sha256 cellar: :any,                 x86_64_linux:  "dbdbfc29f3e6512855a4a564aec7dbce2218dd72f2775b8531ee7cd525d6ebdd"
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
