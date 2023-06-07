class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https://tanka.dev"
  url "https://github.com/grafana/tanka.git",
      tag:      "v0.25.0",
      revision: "ac7f3e9b1f844940af9360eefb20f1005cd6bec4"
  license "Apache-2.0"
  head "https://github.com/grafana/tanka.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f3a2fa62bc8f5ae3da1b3c880c786b97f710d4bde687420d99d98602a888b42"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f3a2fa62bc8f5ae3da1b3c880c786b97f710d4bde687420d99d98602a888b42"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f3a2fa62bc8f5ae3da1b3c880c786b97f710d4bde687420d99d98602a888b42"
    sha256 cellar: :any_skip_relocation, ventura:        "9a3e8cee736fa65731bbe847e5fedffd3b5f1d8d40cd50713d65aac5f6096e53"
    sha256 cellar: :any_skip_relocation, monterey:       "9a3e8cee736fa65731bbe847e5fedffd3b5f1d8d40cd50713d65aac5f6096e53"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a3e8cee736fa65731bbe847e5fedffd3b5f1d8d40cd50713d65aac5f6096e53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be924f6cb53e04ef9c5547564b5f634ae48c56b9ea2507cf36cb737a0f094047"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/grafana/tanka/pkg/tanka.CurrentVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags.join(" "), output: bin/"tk"), "./cmd/tk"
  end

  test do
    system "git", "clone", "https://github.com/sh0rez/grafana.libsonnet"
    system "#{bin}/tk", "show", "--dangerous-allow-redirect", "grafana.libsonnet/environments/default"
  end
end
