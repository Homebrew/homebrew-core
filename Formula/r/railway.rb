class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.71.1.tar.gz"
  sha256 "813807cfc0ea8ee795ff5f58d7a8f9985b0ef521996fbf5753ee756da08b80a1"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ba8dd6e03508f0ff48af3951d613658d811243ca4450a3e48f6c542be5f2a8a5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fcc6fba2382fc5406368211a7abb6dd588c27a0b5785d3af5fefdd0a20ad22f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5c228ea7452b73da440fc4999f698963a61cf5db16d5dec44688eb2ae5ba814e"
    sha256 cellar: :any,                 arm64_linux:       "32ffa1e68c93203755797060c840e4a457afc3a23483811704b9a13d6074ede0"
    sha256 cellar: :any,                 x86_64_linux:      "99a93aac221bd6bd0879d307c77bb464cae5ec28a3bd7af3c35ac09d826869bc"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railway #{version}", shell_output("#{bin}/railway --version").strip
  end
end
