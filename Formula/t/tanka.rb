class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https://tanka.dev"
  url "https://github.com/grafana/tanka.git",
      tag:      "v0.28.0",
      revision: "80ffbfd423f988b14641ee38fc158919c45d8586"
  license "Apache-2.0"
  head "https://github.com/grafana/tanka.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d929808064b439b98161009f51cb3e98f157b49ae9db83ef1f9bfe91d5c6dfa1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d929808064b439b98161009f51cb3e98f157b49ae9db83ef1f9bfe91d5c6dfa1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d929808064b439b98161009f51cb3e98f157b49ae9db83ef1f9bfe91d5c6dfa1"
    sha256 cellar: :any_skip_relocation, sonoma:         "c8ef553cc70b809287dfd987255255103234f13a27097ea2499699522ffcd09e"
    sha256 cellar: :any_skip_relocation, ventura:        "c8ef553cc70b809287dfd987255255103234f13a27097ea2499699522ffcd09e"
    sha256 cellar: :any_skip_relocation, monterey:       "c8ef553cc70b809287dfd987255255103234f13a27097ea2499699522ffcd09e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c5c6b0b911dedd01a9bd4780c1f2052efc14f5bc80c155385933209b9899fe6"
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
