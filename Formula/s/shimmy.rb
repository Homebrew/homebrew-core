class Shimmy < Formula
  desc "Small local inference server with OpenAI-compatible GGUF endpoints"
  homepage "https://github.com/Michael-A-Kuykendall/shimmy"
  url "https://github.com/Michael-A-Kuykendall/shimmy/archive/refs/tags/v1.5.5.tar.gz"
  sha256 "a93cafb7004ce6abb572d494b631eb434eadd27111943ddb626c2fe549f22c0d"
  license "MIT"
  head "https://github.com/Michael-A-Kuykendall/shimmy.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c4859fc5d54dac16c5c08012467f1867efdaa8f62b13b82694f01ed6b9c6ee6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c49a61707c5d95f9c107a27c8bdc605aa006ca00b0882be4dee0260105b249c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1456f2730c75bcea38c9fee4deb6c1e0e0d00490622017acb7a57401eec2640b"
    sha256 cellar: :any_skip_relocation, sonoma:        "63a107e5479ce602027287c65fcc2fa96c6e12bdba115f02200284515254f48d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bde951ee18cadc708479b5c443d9cfd762efa4e55c359fb1be9c9ae7d119a06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65438a49c61000bc5a252c75b8caa430c7cebb33d0bb5566f33cc583f5be067d"
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
