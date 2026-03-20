class Tock < Formula
  desc "Powerful time tracking tool for the command-line"
  homepage "https://github.com/kriuchkov/tock"
  url "https://github.com/kriuchkov/tock/archive/refs/tags/v1.7.14.tar.gz"
  sha256 "a3c6fd68dd34386a2b8f2d789e959e7039dafeaeb4263d07fdfedc5f3b911061"
  license "GPL-3.0-or-later"
  head "https://github.com/kriuchkov/tock.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5cca7bd668a5f667caf078cd3a5f0410af910f0879f5e4055bf27d1a3a251c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fbbd96839760fbf14f5da988c4bba041869a77c25a762018322160e66291571"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfe958d6c8a57bde5989dd60c1e49978137adb082dd323c6c8794871da6696ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "96d22c43f8eee82b81c412690dfbb9602ebbed8ec2e5ff7dece5b2cc07509dd3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f42a3767405c8c2a27ec6a76a71ae82de4ea0dac099d993cf6fce4942a96c28a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1328cded979c2a25d6ddee6c2b0872e303cc07aef635da23190d88623fc8e13e"
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
