class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https://tanka.dev"
  url "https://github.com/grafana/tanka.git",
      tag:      "v0.26.0",
      revision: "965612cecec8466a6f10c1ec1930b59d276b1766"
  license "Apache-2.0"
  head "https://github.com/grafana/tanka.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8da41dcf8db15e3310276bcc50d768c7ec9b713c252b93218df870e92b026408"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8da41dcf8db15e3310276bcc50d768c7ec9b713c252b93218df870e92b026408"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8da41dcf8db15e3310276bcc50d768c7ec9b713c252b93218df870e92b026408"
    sha256 cellar: :any_skip_relocation, ventura:        "4e00f16ba757b0ea0b557df690b8dc697c8444374a255760ead06b73dac33663"
    sha256 cellar: :any_skip_relocation, monterey:       "4e00f16ba757b0ea0b557df690b8dc697c8444374a255760ead06b73dac33663"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e00f16ba757b0ea0b557df690b8dc697c8444374a255760ead06b73dac33663"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86d09905c668f7a125068761df3f4370b0fda3d7b824c63d477263df282cc214"
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
