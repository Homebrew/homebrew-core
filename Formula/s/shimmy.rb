class Shimmy < Formula
  desc "Small local inference server with OpenAI-compatible GGUF endpoints"
  homepage "https://github.com/Michael-A-Kuykendall/shimmy"
  url "https://github.com/Michael-A-Kuykendall/shimmy/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "3afe51eda21b5f4bf982aecfd52518f8bd3748c8a243bc4de025ff5c0f17d785"
  license "MIT"
  head "https://github.com/Michael-A-Kuykendall/shimmy.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b23bd801f6e898debb6c5230c448080ed3df12877c93adc87e46cb5f72d6aa00"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc4a833ecb7614b0bb67158a22e2569114789622ccf2ae2427c9e97ae544ac06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1e17482a3874790cd3d3933b1cb8eec186acec2363844344ae4fadce2a52982"
    sha256 cellar: :any_skip_relocation, sonoma:        "126bff3b1ce1cf914e9e3062693f473fff812905bb8c7021a6bad415b3c40010"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f69dd03680fd62bce588e112ab168625acec79c3a9feb2134562269eff02d1ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a46a7edd1c09deb9e340bdccdbbbfd6e1fb34aff468574eacefac9602919d64"
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
