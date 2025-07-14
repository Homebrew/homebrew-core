class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https://tanka.dev"
  url "https://github.com/grafana/tanka/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "1e18499f0eb96b250d1b1129fc8be7660d67b73bbaa225071d8aa6a90b3f58ef"
  license "Apache-2.0"
  head "https://github.com/grafana/tanka.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "feb7cfaa607e2124d7ad863eba4be63a65e50717f8b84ceba4fde6fb5a4ee465"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "feb7cfaa607e2124d7ad863eba4be63a65e50717f8b84ceba4fde6fb5a4ee465"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "feb7cfaa607e2124d7ad863eba4be63a65e50717f8b84ceba4fde6fb5a4ee465"
    sha256 cellar: :any_skip_relocation, sonoma:        "b87820933d9f6ed422974a344737557a3ba91ab696b2dd8bc2071831bd621af3"
    sha256 cellar: :any_skip_relocation, ventura:       "b87820933d9f6ed422974a344737557a3ba91ab696b2dd8bc2071831bd621af3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b7814d3291301823ecdd656e56b35751a4e0d23754415a81947d810ef13cc23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3aed090b96267bdafaa3b4a6c8543e740ee7bdab58a3a5ca9e92c25b9a9d4c4e"
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
