class Shimmy < Formula
  desc "Small local inference server with OpenAI-compatible GGUF endpoints"
  homepage "https://github.com/Michael-A-Kuykendall/shimmy"
  url "https://github.com/Michael-A-Kuykendall/shimmy/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "c87ee8311588590b95a762940960b2b83b1ea89da968e38886e88d4e86e6a353"
  license "MIT"
  head "https://github.com/Michael-A-Kuykendall/shimmy.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37470a01776ce15d024360bb1f454b128f9bbb58f4da09d1e0b7abae629afdf8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e28c3e3107fb92b671712e9fe205b18d7e4303a7c3ffd216292e5ecf0430d20f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00f0aa1e7007f9f10b2bb5d956c7e9a603b5fc35353f12c8fb3a48d189f9d126"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c0a498e77e2cf853d2b92fed14e32b12aa234ae6d9e9accb101351ca3399d7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20bb98e3e408829925be09043e75a98abc3c77b14b153b730f11db26a42fe8bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9553b8c215287996582e1ede500150fa988370a7303e3f07c019657f38237257"
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
