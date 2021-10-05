class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https://tanka.dev"
  url "https://github.com/grafana/tanka.git",
      tag:      "v0.18.1",
      revision: "ba3b0d5e11587b45434fbe11297d5194709cd159"
  license "Apache-2.0"
  head "https://github.com/grafana/tanka.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e5bfc760fc6b945546c1246823f5ea9e2b602d0c9dad69d8d92c23e8f605ef74"
    sha256 cellar: :any_skip_relocation, big_sur:       "3462e4b57d5b3fb4b9caee0d15f017f55de1997d82b439336d60b47556159b3d"
    sha256 cellar: :any_skip_relocation, catalina:      "a0457f5d5071d22e7bc87bfc5eb8752f057d9131b2fa4305a2165e5cb0bc4bd6"
    sha256 cellar: :any_skip_relocation, mojave:        "6b05a83dbf93eb18e7c966b97660e183ae20d8b9377f8d57cb43529ea07733fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52824eb9e3e031f487a4c8d152a9ba3c3fa3a1919bb4b58b558ccec78dd886e1"
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
