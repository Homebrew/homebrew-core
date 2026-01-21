class Tuios < Formula
  desc "Terminal UI OS (Terminal Multiplexer)"
  homepage "https://github.com/Gaurav-Gosain/tuios"
  url "https://github.com/Gaurav-Gosain/tuios/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "0a64b1381b276f00038ae05e8ab8963f486a8f0d7da09383be84e147e2cc7834"
  license "MIT"
  head "https://github.com/Gaurav-Gosain/tuios.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5fb2a54385290a39e1463fa4dc77dc374f56aeeaa2e862d1abc257bf1524e319"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acd127d4a745b13713c7dd9c08d96f28888e4cfde1dbdfbd86930218a796845b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "313c907bbca23c6e1cb3738e470dd04fdcfaf0438cc47cfd78d05bba0bce8261"
    sha256 cellar: :any_skip_relocation, sonoma:        "e706487018295439922af957114e154bafc386ee7ec38aa39c7857300d50f10a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37566ad6d56fe46142a6dc448718bb70ea24ab932d4141e6e6d536fa6cecaf11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "421be098ea1963a07b1167b94a7888df3ccf089073d86afdb0a413b2c2dcef0c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601} -X main.builtBy=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/tuios"

    generate_completions_from_executable(bin/"tuios", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tuios --version")

    assert_match "git_hub_dark", shell_output("#{bin}/tuios --list-themes")
  end
end
