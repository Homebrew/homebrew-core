class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https://tanka.dev"
  url "https://github.com/grafana/tanka/archive/refs/tags/v0.36.3.tar.gz"
  sha256 "18472e35c36d56489464e113c720f32ab5c8e6ef57d14b55faa2e774dfa3f91b"
  license "Apache-2.0"
  head "https://github.com/grafana/tanka.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05939160a82cc0678bb88eca469bb26ee1af28fdea4ed2c6ef80fc84d10474b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05939160a82cc0678bb88eca469bb26ee1af28fdea4ed2c6ef80fc84d10474b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05939160a82cc0678bb88eca469bb26ee1af28fdea4ed2c6ef80fc84d10474b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8e351e56755adf054e5f30106ad392adca9075dc94e52f14c6f9b5a7fb308e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fbbc8d142cbe680ab68e0b81fd05ec7c382b66ce6f4eac22441c5c17b14397bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6e54c7561f2d182ad471fad5b027f1fd21eb77d52f2242d33e6ad9b7b06ce90"
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
