class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https://tanka.dev"
  url "https://github.com/grafana/tanka/archive/refs/tags/v0.36.1.tar.gz"
  sha256 "bd2e7ddf4804437f85061bce30d84ffab1035027335bdf9ef5536f95b0584b00"
  license "Apache-2.0"
  head "https://github.com/grafana/tanka.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67279372fbedeaaa5074d1d395a30508d33741ea25181af3e203347e477a8364"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67279372fbedeaaa5074d1d395a30508d33741ea25181af3e203347e477a8364"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67279372fbedeaaa5074d1d395a30508d33741ea25181af3e203347e477a8364"
    sha256 cellar: :any_skip_relocation, sonoma:        "afd9f94a4c8cee276e5fe60c35ae61818337bd27d3f3b85c811334b3803a423e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "676c1acc773d696cfd2f3fe1283873ebc4273f4de80c8bc39a6420ffa1a8b1cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2acfdfb9f5a53d8df9181767c4166bfacaf55dabf7668db62251ff3ae4a73b16"
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
