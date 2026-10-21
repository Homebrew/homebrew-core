class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https://tanka.dev"
  url "https://github.com/grafana/tanka/archive/refs/tags/v0.39.4.tar.gz"
  sha256 "abf9585c22aca859ee2736a876a3d8622dbe277d53b669fe76c463d8ebdd1f7a"
  license "Apache-2.0"
  head "https://github.com/grafana/tanka.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "66951e787cbf8fad9ce5630500e1b2c87ff698483f05027e3c6bc47ccca89c33"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "66951e787cbf8fad9ce5630500e1b2c87ff698483f05027e3c6bc47ccca89c33"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "66951e787cbf8fad9ce5630500e1b2c87ff698483f05027e3c6bc47ccca89c33"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c754a2c7d0bead02af7c40e069eba8b4f6141b80abe11d3fe81c2b9a779339b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "3e4260980c2938a3f759b1fc242b7a99f2cc34c1c6e4001b5eba9c6638fb47b9"
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
