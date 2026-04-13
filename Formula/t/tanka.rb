class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https://tanka.dev"
  url "https://github.com/grafana/tanka/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "ade9875e6e18fc2f336a1bb67304dfab7aa5520ce941dad82e8cf4c0db346c1a"
  license "Apache-2.0"
  head "https://github.com/grafana/tanka.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a9a1e0517d0d0010b2a0a91529b9574e4f601f5a805afa8ba8c4f84798643d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a9a1e0517d0d0010b2a0a91529b9574e4f601f5a805afa8ba8c4f84798643d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a9a1e0517d0d0010b2a0a91529b9574e4f601f5a805afa8ba8c4f84798643d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee566f7519f29b903319291623debe26da8b2e7578836cbc5821fe72459c798b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e303e9ab9f7e2e16468b3dd298a8c04823a56dcfe0d78a14db99033d65abbfc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "181527e0e9a22a53c9e732337cd4e4189bfbe046a0358ebd6bedfba0872cd54a"
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
