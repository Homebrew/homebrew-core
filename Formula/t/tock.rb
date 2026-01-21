class Tock < Formula
  desc "Powerful time tracking tool for the command-line"
  homepage "https://github.com/kriuchkov/tock"
  url "https://github.com/kriuchkov/tock/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "bd43b2d3e59845cde23de2930b5e9067ca7a4113b28dc2a04b02b635b743032c"
  license "GPL-3.0-or-later"
  head "https://github.com/kriuchkov/tock.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24601228020b270619768ce4395a1639a199967918a026c81ccbf23c8dc30577"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24601228020b270619768ce4395a1639a199967918a026c81ccbf23c8dc30577"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24601228020b270619768ce4395a1639a199967918a026c81ccbf23c8dc30577"
    sha256 cellar: :any_skip_relocation, sonoma:        "56d6adc6e5f5e5e01d2d8833e04df282e2007c9981e73b706735c60a74a58600"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e86ecbd9ef88b516d2c8a1ec5776864c2ad99d8c45c1a70b2439c5c5d92958f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a5082cdc1e8fc4b3db91b85d73da812c17e717fda57bb671dba3bc4ae2d8e3a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kriuchkov/tock/internal/adapters/cli.version=#{version}
      -X github.com/kriuchkov/tock/internal/adapters/cli.commit=#{tap.user}
      -X github.com/kriuchkov/tock/internal/adapters/cli.date=#{Date.today}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/tock"

    generate_completions_from_executable(bin/"tock", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tock --version")
    assert_match "No currently running activities", shell_output("#{bin}/tock current")
  end
end
