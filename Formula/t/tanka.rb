class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https://tanka.dev"
  url "https://github.com/grafana/tanka/archive/refs/tags/v0.38.0.tar.gz"
  sha256 "aaff4b21c0d3a5b67cc9a42c77d8a6922533f887178d095217d0d28482a1cf67"
  license "Apache-2.0"
  head "https://github.com/grafana/tanka.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b10e3e08e64520fac78033341590f038859f8717386f73c9f013d32c7cdd6bfc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b10e3e08e64520fac78033341590f038859f8717386f73c9f013d32c7cdd6bfc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b10e3e08e64520fac78033341590f038859f8717386f73c9f013d32c7cdd6bfc"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3ffac02a2d59bfa7e9e290d8880bdddf2711906a9ba19ef54d5398b8ac31169"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f63b60e95cad3ebd886ee3927ccf97886df9b6de2eb7b2153945549e346bd488"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4caaa1567340b6d03e9befc11a6ebdcf30a3a677c6fe89342e24a66acf50fb3f"
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
