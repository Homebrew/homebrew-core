class Shimmy < Formula
  desc "Small local inference server with OpenAI-compatible GGUF endpoints"
  homepage "https://github.com/Michael-A-Kuykendall/shimmy"
  url "https://github.com/Michael-A-Kuykendall/shimmy/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "d761c96a497263a19a2d4a78ddfe248e5c8c0b896ff535d15ac31b47032761e4"
  license "Apache-2.0"
  head "https://github.com/Michael-A-Kuykendall/shimmy.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d85b61e80d9813435cf33fa36e3eea5ff340ade69716ae62ec5bb0b6504ca4a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61033bda5f5d7a6a5ac77ac2b90b0ecd9eb1c05d46c6759f092d20c56a3ec605"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de47e2e1b3ff8dcb2a1aebe33545a2db69456413959eeacf3b9a2ee86770064b"
    sha256 cellar: :any_skip_relocation, sonoma:        "280c53fde0c1db2f4402a2d366b9e82e36debf79a4737b3f4c181c74b7b12ac8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "125faf23f0288a2fe2d6fd046ad38041e82f70ee5f4d05cacac1ea97821134cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9a2c596f5a1309fa9aea970c9cbdd1a95d1232b1c486c60a299b693bd933e29"
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
