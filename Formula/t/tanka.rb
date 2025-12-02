class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https://tanka.dev"
  url "https://github.com/grafana/tanka/archive/refs/tags/v0.36.2.tar.gz"
  sha256 "16ad570b4e136ccb030c9933284171969fc7e520a2580ed6e02d6bd21a36b6d9"
  license "Apache-2.0"
  head "https://github.com/grafana/tanka.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1eb593a9218504e1fa4660af623283805b43aa472658c695f00cc47e37a0823"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1eb593a9218504e1fa4660af623283805b43aa472658c695f00cc47e37a0823"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1eb593a9218504e1fa4660af623283805b43aa472658c695f00cc47e37a0823"
    sha256 cellar: :any_skip_relocation, sonoma:        "318e4f58c26fff311adae3109697abce51802bee3daccc8a8d7025d6da641b48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "458584a93f96622bdc55e71a75fcef2af67f10ae7778c0bdf73f1227a2bbd5e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51a05e89f3ca2ae1e698294e3aa6b562947dbb1e6d3cfa104c981f33dddff654"
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
