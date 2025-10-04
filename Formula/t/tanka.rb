class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https://tanka.dev"
  url "https://github.com/grafana/tanka/archive/refs/tags/v0.35.0.tar.gz"
  sha256 "2a74a22b2cd13c4b2b4a76b3c855b43b75adf1569c3f40b14a98fd11bc65f230"
  license "Apache-2.0"
  head "https://github.com/grafana/tanka.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba5f87f1a0bf34796946413f0507b6f7f44862de0a11207fa7d8421695a43aa0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba5f87f1a0bf34796946413f0507b6f7f44862de0a11207fa7d8421695a43aa0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba5f87f1a0bf34796946413f0507b6f7f44862de0a11207fa7d8421695a43aa0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ba5f87f1a0bf34796946413f0507b6f7f44862de0a11207fa7d8421695a43aa0"
    sha256 cellar: :any_skip_relocation, sonoma:        "90c897898b81e7717985a96fbeddeea2866dd462b10cfdc6294e56561e3177c9"
    sha256 cellar: :any_skip_relocation, ventura:       "90c897898b81e7717985a96fbeddeea2866dd462b10cfdc6294e56561e3177c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45f6db59b95d3e5473efc91f85afe5a672337401baafef0fb53a94cb75426ba8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b5e7865362e8c922da248429736a650f8ed87b3fa840e9c49e0eb9dbb473c6f"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/grafana/tanka/pkg/tanka.CurrentVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"tk"), "./cmd/tk"
  end

  test do
    system "git", "clone", "https://github.com/sh0rez/grafana.libsonnet"
    system bin/"tk", "show", "--dangerous-allow-redirect", "grafana.libsonnet/environments/default"
  end
end
