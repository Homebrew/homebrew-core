class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https://tanka.dev"
  url "https://github.com/grafana/tanka/archive/refs/tags/v0.36.4.tar.gz"
  sha256 "84737638cc6e127262d106f0bf3bdcc912bdb08b02e389efae94e9bf1c61f292"
  license "Apache-2.0"
  head "https://github.com/grafana/tanka.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1276ee125579e972abda6f0c226f0fcf8d3a6737154a0967d0a303d247060b25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1276ee125579e972abda6f0c226f0fcf8d3a6737154a0967d0a303d247060b25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1276ee125579e972abda6f0c226f0fcf8d3a6737154a0967d0a303d247060b25"
    sha256 cellar: :any_skip_relocation, sonoma:        "ede736edc01e96087f1a71ea509aa62f67c5aac186ce7733de98b635d6881b9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81a4c83a2e8948f26e975747595008e54d49cd6b61bf43733075f66b5d983917"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6af705576f17e70a13c9b08cc5444d14671ad420a04e9b9235f8ed9b1567060f"
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
