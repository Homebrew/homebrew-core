class Tock < Formula
  desc "Powerful time tracking tool for the command-line"
  homepage "https://github.com/kriuchkov/tock"
  url "https://github.com/kriuchkov/tock/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "37d3f83487c12371abadd60f8f5d9c90986ef7a42f5f3d72d2489403c842a63f"
  license "GPL-3.0-or-later"
  head "https://github.com/kriuchkov/tock.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d52d25527a611f64fbd3cc944b58946ebdccdac25dd6b74466eb351058b9a0e7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "37758288a6ffcf37c75f5d96abcee2d110f9f66edf96b235ee26bc163b8cf8e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "29455497da608b442007b0c1a1feb5d7b05b6f417e231aba1604839aa9e7fe4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "940e95c36d639e64669a4a998b6f1b0b50531d427ff17fbbc74a00812a7b7d4f"
    sha256 cellar: :any,                 x86_64_linux:      "0b69f76cc5d456c648c0ee4b34e1d3906579cc195b83da940b69bd9ff00a8c88"
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
