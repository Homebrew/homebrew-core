class Shimmy < Formula
  desc "Small local inference server with OpenAI-compatible GGUF endpoints"
  homepage "https://github.com/Michael-A-Kuykendall/shimmy"
  url "https://github.com/Michael-A-Kuykendall/shimmy/archive/refs/tags/v1.5.6.tar.gz"
  sha256 "092430a73c8d0c5651389a8c8011a46ac58c4d6a4a0b104d7a9de760544884bb"
  license "MIT"
  head "https://github.com/Michael-A-Kuykendall/shimmy.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08f8039b833bc5bea06cefaf3ea272821596a871bf20a8c2375c953b6b250c62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04163b965f96b5fe7ba805e1fd04ef6dc3964c072045e66f0f5de4e9b2c1f9c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6165d2df7bd643ca42f4b1a262d9074c84a88eaa9c730cb5d98b58b1bd73a6cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "691ae23eb361236b4b59a3144c2ebe94a6bfdc6c8f8aa07317a705beaab64e86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2521a5c4aa6752e08c4be3601d46167acb55edb524e045bb417aa2e94498a42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0975b9ae1ec0e146e856758cada1038d62ab9cda96e6a63baa135e55a767628b"
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
    assert_match version.to_s, shell_output("#{bin}/shimmy --version")
    output = shell_output("#{bin}/shimmy list")
    assert_match "Total available models: 1", output
  end
end
