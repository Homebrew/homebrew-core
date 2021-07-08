class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https://tanka.dev"
  url "https://github.com/grafana/tanka.git",
      tag:      "v0.17.1",
      revision: "3bc0931b899432ab1e9edcff9c4e81a1bd3250b7"
  license "Apache-2.0"
  head "https://github.com/grafana/tanka.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "696aedf11003ba41070123f71491f19343ff6ef53e62ece4f2d80736b9b071eb"
    sha256 cellar: :any_skip_relocation, big_sur:       "ff8cb42c06ff948edf26801daa7f6c0977c90861ee87ae671c207edf95ee7c50"
    sha256 cellar: :any_skip_relocation, catalina:      "d506f4720eae0ed294b93c4513e0a7f6f2fc1c2fc83e77881ae225455ae9449f"
    sha256 cellar: :any_skip_relocation, mojave:        "60e43b3b9233d2e1d447b11be0864307148fd94d73590e8173c9d343469ce2c5"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    system "make", "static"
    bin.install "tk"
  end

  test do
    system "git", "clone", "https://github.com/sh0rez/grafana.libsonnet"
    system "#{bin}/tk", "show", "--dangerous-allow-redirect", "grafana.libsonnet/environments/default"
  end
end
