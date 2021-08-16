class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https://tanka.dev"
  url "https://github.com/grafana/tanka.git",
      tag:      "v0.17.2",
      revision: "21707748759473bb5f28b61af0b1878000a4b998"
  license "Apache-2.0"
  head "https://github.com/grafana/tanka.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "be8fa0d5ed31dac99021a66c12a358cdf2240f4ad400b290ab0ec28f0bbc09c2"
    sha256 cellar: :any_skip_relocation, big_sur:       "8cec271ba7b1fb7404b5ab0aefdc9b780ab459b65977e6150969b6195210b820"
    sha256 cellar: :any_skip_relocation, catalina:      "b7ac59f1786caf1b0d035fcd79e6e39d5d7bf3868fa7446702dac1ea06d615bb"
    sha256 cellar: :any_skip_relocation, mojave:        "923e8dfac38839ea75b3b460a0380d3be6963a2f9ed59b3a1e75e983de1d9f66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a05efb507ba735ca2d2bb6909607d3cead0ba9b8da7665243b217b95179b760c"
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
