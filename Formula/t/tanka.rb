class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https://tanka.dev"
  url "https://github.com/grafana/tanka/archive/refs/tags/v0.40.2.tar.gz"
  sha256 "8c9c710f446ce1e5c0cd8a76a2bf54854e5a487dc5216c1565a2f8f8a58d6dad"
  license "Apache-2.0"
  head "https://github.com/grafana/tanka.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "71e3856dc2fe88150a82631428a2fd3164304cdd5c5c0d15f435a35ac56ee795"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "71e3856dc2fe88150a82631428a2fd3164304cdd5c5c0d15f435a35ac56ee795"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "71e3856dc2fe88150a82631428a2fd3164304cdd5c5c0d15f435a35ac56ee795"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8fa5fc46672281d7dbee5b33a79f005bbdcc6df23bc14312ee98168bedda54eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ddfde7c08628e754e60b058dc6381f89ab3ae7dc8dcc3f2c86ffa40acadd1cb7"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[-X github.com/grafana/tanka/pkg/tanka.CurrentVersion=#{version}]
    system "go", "build", *std_go_args(ldflags:, output: bin/"tk"), "./cmd/tk"
  end

  test do
    system "git", "clone", "https://github.com/sh0rez/grafana.libsonnet"
    system bin/"tk", "show", "--dangerous-allow-redirect", "grafana.libsonnet/environments/default"
  end
end
