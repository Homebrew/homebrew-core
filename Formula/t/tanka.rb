class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https://tanka.dev"
  url "https://github.com/grafana/tanka/archive/refs/tags/v0.39.1.tar.gz"
  sha256 "0492de3c3e5e55cfbcfc40f181293c63e6d04928f757b5d96e0eade0b849d2ab"
  license "Apache-2.0"
  head "https://github.com/grafana/tanka.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9e3541d85940e17dfb89927be471974ad9aad4801eaa7c941687254b978475f4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9e3541d85940e17dfb89927be471974ad9aad4801eaa7c941687254b978475f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9e3541d85940e17dfb89927be471974ad9aad4801eaa7c941687254b978475f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a29b75a354e0778d73b96a00a0b8601aff4efe1bca49d63d0486127e70bd5a9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "2efcb069cd7b8b462ae29efc1c8a31477fc27837442ab9407e803266f6f47380"
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
