class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.75.0.tar.gz"
  sha256 "7a9775338cfc6965a770ee9af18f3309b92d7591e6744c8d0f3e766c5d68a8d9"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bab696c98f44e152fff21aa715e20e6ee85346930372f2c8b7b5892aaf224970"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "68c63a6913081e67bfb3e454fa1f7902b33bd5096f394748ba2265c8f1b962d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "421c7aea067719407432d16c4112ece10bf9c5024f600835da756c9617012085"
    sha256 cellar: :any,                 arm64_linux:       "9dd33ffdea70dade666484949a63fa1adf884d462c063160896562a1221750fa"
    sha256 cellar: :any,                 x86_64_linux:      "c6084822c5283fc1394b12fd42f679f522910dd8e67fe05e410caff7a83c1d71"
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
