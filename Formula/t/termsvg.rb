class Termsvg < Formula
  desc "Record, share and export your terminal as a animated SVG image"
  homepage "https://github.com/MrMarble/termsvg"
  url "https://github.com/MrMarble/termsvg/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "193c8004a8c91b49518ecb5712009369035092288bb2a1189d188f2410332bae"
  license "GPL-3.0-only"
  head "https://github.com/MrMarble/termsvg.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "da3f11e794b6e28d4eb0b847d7b08e5f1494e53faae351873dde36e1a1d06578"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "da3f11e794b6e28d4eb0b847d7b08e5f1494e53faae351873dde36e1a1d06578"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "da3f11e794b6e28d4eb0b847d7b08e5f1494e53faae351873dde36e1a1d06578"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fe741767b8da9ccc3a333b23bbfaf918a74e7b5b4a24bfc34ec2ec8e001f1c67"
    sha256 cellar: :any,                 x86_64_linux:      "907f6b7f8542957b75436599a841f72162f5e0d9d339eeccdd06421797931e9b"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/termsvg"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/termsvg --version")

    output = shell_output("#{bin}/termsvg play nonexist 2>&1", 80)
    assert_match "no such file or directory", output
  end
end
