class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https://tanka.dev"
  url "https://github.com/grafana/tanka/archive/refs/tags/v0.37.2.tar.gz"
  sha256 "9b960d272c415c7ef2374cb7debc55fed1d4bed858c6aa8517114fac5a148900"
  license "Apache-2.0"
  head "https://github.com/grafana/tanka.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92807134801b160539860d0cbf6a81723826ffd1556a092e95c8aef2c074ba6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92807134801b160539860d0cbf6a81723826ffd1556a092e95c8aef2c074ba6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92807134801b160539860d0cbf6a81723826ffd1556a092e95c8aef2c074ba6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "89b38c2afccefa36bc52d0746cf7448735ea5637169b507662b28b29a840205d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb10b7c031c80d6059df02634c82919b4a95f9095af27c0edcf447588baf60fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "985347cb468d43ab645d2451179afe54dc756995157c882844b9ae4927790657"
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
