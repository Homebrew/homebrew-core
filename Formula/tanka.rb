class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https://tanka.dev"
  url "https://github.com/grafana/tanka.git",
      tag:      "v0.23.1",
      revision: "e53e74b26e14cfcb320602badb471d0c34a24155"
  license "Apache-2.0"
  head "https://github.com/grafana/tanka.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "472a24893c2a4a66d250572026f9cbd4276bcaf3d0be319a7772fc915a4a43a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "472a24893c2a4a66d250572026f9cbd4276bcaf3d0be319a7772fc915a4a43a0"
    sha256 cellar: :any_skip_relocation, monterey:       "361f05bd1975f9f2e012f467feba018759c5fdf92959b2d659adfd8695b27454"
    sha256 cellar: :any_skip_relocation, big_sur:        "361f05bd1975f9f2e012f467feba018759c5fdf92959b2d659adfd8695b27454"
    sha256 cellar: :any_skip_relocation, catalina:       "361f05bd1975f9f2e012f467feba018759c5fdf92959b2d659adfd8695b27454"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d376369b9c1c6fdf9bd4b6fcefb5ce20dbde34c6b0fe38a8f13021174a47581"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/grafana/tanka/pkg/tanka.CURRENT_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags.join(" "), output: bin/"tk"), "./cmd/tk"
  end

  test do
    system "git", "clone", "https://github.com/sh0rez/grafana.libsonnet"
    system "#{bin}/tk", "show", "--dangerous-allow-redirect", "grafana.libsonnet/environments/default"
  end
end
