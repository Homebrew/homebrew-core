class Tock < Formula
  desc "Powerful time tracking tool for the command-line"
  homepage "https://github.com/kriuchkov/tock"
  url "https://github.com/kriuchkov/tock/archive/refs/tags/v2.0.9.tar.gz"
  sha256 "0d4183ac42302b48bc40e59ce0d7144ff0fad2492c1764385d87bd0ee539d82b"
  license "GPL-3.0-or-later"
  head "https://github.com/kriuchkov/tock.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "30cacfc6a152a386dba241ec06a28d11aa6fc87f183e1bebdb776b038377c019"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "29efc3578d4f29b6d83aec736d5dd3c9d908d83936ee9c4d39ede99791b0de9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ee76bacbce5f463ff09dc8bbc26d71d80c9a834d36acc270387e4b43cd8d0b3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7130b38ec37077a8261da866920c9af7ebf96f57c0c5f3038ae297af6b0cbce0"
    sha256 cellar: :any,                 x86_64_linux:      "f4d324e366ec172c0f2fa4554801ec7659ec67053a66102ece4984ace598bfd9"
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
