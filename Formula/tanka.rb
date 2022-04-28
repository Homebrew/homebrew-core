class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https://tanka.dev"
  url "https://github.com/grafana/tanka.git",
      tag:      "v0.21.0",
      revision: "68d625e128b2678996ff442c385f5361c7987491"
  license "Apache-2.0"
  head "https://github.com/grafana/tanka.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66fa72d37793d5c5276c4764d11da218480f325e52bedf8f69bb14674bef1cbc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1d82566c1c6a7d409deea82bbfb12c6724511f1f319ca82bd64a0d0bbc9d87cb"
    sha256 cellar: :any_skip_relocation, monterey:       "4ec403c12967aa672d6312e99d3d0fde805f71a4981458ba73b43239fa77ae79"
    sha256 cellar: :any_skip_relocation, big_sur:        "84d4c9183535b86bdfb37e49a930df17250c50fef357b5643ad9525c8ae520db"
    sha256 cellar: :any_skip_relocation, catalina:       "71adc0ef7a995017388c1dfa189c95922c46e2140bde7f37dda0e823cb32e467"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "095fa8fc9b4b0db0701a429898732e2dd81694d1adb563bc032b1a51c8e41574"
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
