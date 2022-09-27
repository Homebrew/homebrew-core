class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https://tanka.dev"
  url "https://github.com/grafana/tanka.git",
      tag:      "v0.23.0",
      revision: "1bac47d8fb13a707e03d055573d0cdaab5a83b7d"
  license "Apache-2.0"
  head "https://github.com/grafana/tanka.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d763332d1fe381e9ebd93051ae94d1a055e064647fb6456fdf64c3662f6bcae8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d763332d1fe381e9ebd93051ae94d1a055e064647fb6456fdf64c3662f6bcae8"
    sha256 cellar: :any_skip_relocation, monterey:       "3a81a8efadf9bf91865374e4033a9a16eafbd379992984b427d10df31ff84322"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a81a8efadf9bf91865374e4033a9a16eafbd379992984b427d10df31ff84322"
    sha256 cellar: :any_skip_relocation, catalina:       "3a81a8efadf9bf91865374e4033a9a16eafbd379992984b427d10df31ff84322"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f5fea4572a64cdb750cd912425e5c6c23cb57231172721d2f5ce27bc21d00aa"
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
