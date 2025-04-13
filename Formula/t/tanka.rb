class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https://tanka.dev"
  url "https://github.com/grafana/tanka/archive/refs/tags/v0.31.3.tar.gz"
  sha256 "b4f44d9d3f09e8b7b1e39a534e4cc9379c0dde63f7a8942eabb28200b021e38d"
  license "Apache-2.0"
  head "https://github.com/grafana/tanka.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63a079d7bbd728a5d9a4e0a24e810259eb7902e63d9fb92819f92d42604a0e61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63a079d7bbd728a5d9a4e0a24e810259eb7902e63d9fb92819f92d42604a0e61"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "63a079d7bbd728a5d9a4e0a24e810259eb7902e63d9fb92819f92d42604a0e61"
    sha256 cellar: :any_skip_relocation, sonoma:        "d96e07d734bc5edcf536071bed1a7823a7b14bd8db1dbaf8d9415793863f67bb"
    sha256 cellar: :any_skip_relocation, ventura:       "d96e07d734bc5edcf536071bed1a7823a7b14bd8db1dbaf8d9415793863f67bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc9ba708d09ce859474f500d3f6738d5dedd3924cdd0c1ae9c5f559f3bfc2808"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66b7f5a4be1ac6269df5025cf0beae1408a000ad3b5b3e0bee0a6fd2205d14ee"
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
