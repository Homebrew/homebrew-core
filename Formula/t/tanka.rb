class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https://tanka.dev"
  url "https://github.com/grafana/tanka.git",
      tag:      "v0.28.4",
      revision: "858c419dbf65e7fea9ccf58c2329d77ed009f223"
  license "Apache-2.0"
  head "https://github.com/grafana/tanka.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4904b1190a224be8fe9820884bb9baeaa120a90bc597f75be9170f8b6a16448e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4904b1190a224be8fe9820884bb9baeaa120a90bc597f75be9170f8b6a16448e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4904b1190a224be8fe9820884bb9baeaa120a90bc597f75be9170f8b6a16448e"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e264cef5534374e9b3bcf9a0583107c9d16bf16f1418b4a718f3941f284eac7"
    sha256 cellar: :any_skip_relocation, ventura:       "5e264cef5534374e9b3bcf9a0583107c9d16bf16f1418b4a718f3941f284eac7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afc90e5f58b3efc170fabee9bd77047bf8c8fdd8d3a87ec208acdc609d02ac50"
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
