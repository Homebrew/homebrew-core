class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.57.0.tar.gz"
  sha256 "864403c9309d8553c7a73e8855c43c62a110b05edba1433e2893298424a71bab"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1fe1a0a0df318849c0a9e269c45159ae3c9eb147c301afd7a4ebd14be08ccdd5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3326f9dcfd559ede8d89d52d425ffde3b11894caaa8dc4142d408a220d75035b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1a1ef295a45983acdea4865874607d4bdeafdc6d72ffca0300c6693f9e211309"
    sha256 cellar: :any,                 arm64_linux:       "8565ba28e211d97bcc1e07c0504cc88e2c2498f23f3749608b62413c7c1327b1"
    sha256 cellar: :any,                 x86_64_linux:      "28925e7ece34e77aa18a3acaec76a9e40833768c573d1d4cf812a6852efe997b"
  end

  depends_on "rust" => :build

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
