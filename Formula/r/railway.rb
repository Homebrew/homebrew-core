class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.71.0.tar.gz"
  sha256 "953b79a2d4422344a64ef2929487a66ebc3e1f67b4024116a55c8da8eebffba3"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "98746a68f5a5f5554bf9cae339f8e5e7635f381679d6ff5cf1a13d6628fefdd0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "479c1f3a6e17b8aab27dfc9fd5dafcead8574cc9f41d34b41dd873df7ef4e902"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d614b0b9256342965eb4ab21f19045c938f3cda38e2a374c549fca4c64218548"
    sha256 cellar: :any,                 arm64_linux:       "92d8e30809e30946187d789608932712d0e0a8fff5736801974148b08848ce4e"
    sha256 cellar: :any,                 x86_64_linux:      "1572a79b1561aab90fcd44a06ec82b612a0345d812486ac595117e69fd8b8984"
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
