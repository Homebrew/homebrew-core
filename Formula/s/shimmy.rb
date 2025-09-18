class Shimmy < Formula
  desc "Small local inference server with OpenAI-compatible GGUF endpoints"
  homepage "https://github.com/Michael-A-Kuykendall/shimmy"
  url "https://github.com/Michael-A-Kuykendall/shimmy/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "96f74cde3eaea30dcf48565118711c052281d55589f91d4091d307a661291408"
  license "MIT"
  head "https://github.com/Michael-A-Kuykendall/shimmy.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6400afaafece05ad4406750514e5a251cfb54f5abce58abec1072afb8f55000b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e48acf1fa25ab8d3d1afdb3812f30fb348a1661f6b56d1dc19e57af26fe20801"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4619e83dc414b75bda63b2381c5260be7d93f65e43d555e61e997d064c7e3e4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c57dd7b4cbee137b809b106c711cf28378d90e8ea429449bd2f44d8518005a5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a0376feddd4d83e40ec0fc4db48a67969db4e1f9aae979125379d6b6e0e474b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b19863daa99fa6e22b0ccf32085dfc35ceb0b2b3471d8438704a04e2d28b086c"
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
