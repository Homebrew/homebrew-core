class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https://tanka.dev"
  url "https://github.com/grafana/tanka/archive/refs/tags/v0.37.5.tar.gz"
  sha256 "79bdc6917e5e04a85905a707a51b376db6dcc7dd76b65c0b47355829d301c33a"
  license "Apache-2.0"
  head "https://github.com/grafana/tanka.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2554b47e45873cf64e574545a4916afeb79d725e433362e92e88724848952b46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2554b47e45873cf64e574545a4916afeb79d725e433362e92e88724848952b46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2554b47e45873cf64e574545a4916afeb79d725e433362e92e88724848952b46"
    sha256 cellar: :any_skip_relocation, sonoma:        "969005e3633494965205a1ac8c71535d8235c13aad787665f780edcf81aff67f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2a326aef870b6b8dfde49bf149122a18d2085278a448b36854d0339399f3790"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b64600616c7048af7635939291c79d64f712a34b2d4bc1d9953830fb9a40b4c"
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
