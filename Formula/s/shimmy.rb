class Shimmy < Formula
  desc "Small local inference server with OpenAI-compatible GGUF endpoints"
  homepage "https://github.com/Michael-A-Kuykendall/shimmy"
  url "https://github.com/Michael-A-Kuykendall/shimmy/archive/refs/tags/v1.7.4.tar.gz"
  sha256 "227fe3708502745fa7dfde6234efe66752b8e1d2bfa6f8ba4f30095dcf73a23a"
  license "MIT"
  head "https://github.com/Michael-A-Kuykendall/shimmy.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7bf66dd6124256be6ad78ccd6203ce25b12d0d29a99b5bb131c06653afc929a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d5c3cbc8095122f5e22b8ed3f62500a8acc88f8ff2ec7b6779f1b2ac3a937d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8889f2539085581723daa90e59d775de53957aebbf0e3d835f96f597cbe2fafa"
    sha256 cellar: :any_skip_relocation, sonoma:        "15d8116445f9f6337475915e0d8fb98d8b1bd61326c085e90d90d7eb90015578"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9a798d1875d03bc8acc68aa2b9635a5e8ddbf5f326ae995c79cd421daef27e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78f7c0be3ac47f5e99db726d947dd8327eaf20aaf982f1e100be50e87f986b82"
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
