class Tock < Formula
  desc "Powerful time tracking tool for the command-line"
  homepage "https://github.com/kriuchkov/tock"
  url "https://github.com/kriuchkov/tock/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "6ed986f267d2d1fcb84d407c7a371f6db2304dd2960ac2d039fde7cc7784d593"
  license "GPL-3.0-or-later"
  head "https://github.com/kriuchkov/tock.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a7cb2cc25849526cc2e52ab7b3e8e43200b49bd0b8c15db74f4e20f8309a877b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "825c693755b2355c35672e5bb29b9dfef61d81ce93b9beb81d2269b989cc2865"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "aa1cd22053716483f9ce6f206ba03156b98077cd3208046573500b610164e707"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4fefddfe9304e35e39ee0b5a48b5bb86c6c64e7c824febeedeb99f403e032648"
    sha256 cellar: :any,                 x86_64_linux:      "d507f27be25283772c55b06d861374b91809fed75a33b144a871eb0add71e219"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/kriuchkov/tock/internal/app/commands.version=#{version}
      -X github.com/kriuchkov/tock/internal/app/commands.commit=#{tap.user}
      -X github.com/kriuchkov/tock/internal/app/commands.date=#{Date.today}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/tock"

    generate_completions_from_executable(bin/"tock", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tock --version")
    assert_match "No currently running activities", shell_output("#{bin}/tock current")
  end
end
