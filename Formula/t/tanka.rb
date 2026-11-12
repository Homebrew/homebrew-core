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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "882db9e0bff10d2d84d1318eca4ba54b326871c2c263aaaeb4577dd0a6fb00fe"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "882db9e0bff10d2d84d1318eca4ba54b326871c2c263aaaeb4577dd0a6fb00fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "882db9e0bff10d2d84d1318eca4ba54b326871c2c263aaaeb4577dd0a6fb00fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2f2e2a4ce82358dfdfa17bbc82609eb9692ccdc6b98b272e071c6e8f34580c9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "78c19f965ffb5fb2d932927bba66e39c4d29c68ab6e97e02cc3ffa9ef8536923"
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
