class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https://tanka.dev"
  url "https://github.com/grafana/tanka/archive/refs/tags/v0.37.4.tar.gz"
  sha256 "979de90bac45cf0f87e6b03b2a9a588648524f712da41906e32faa27d6fcbbb4"
  license "Apache-2.0"
  head "https://github.com/grafana/tanka.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "502f40bf16b8a309154135d167e71d0f9d2f0baede0f28ea3ef23405c38336fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "502f40bf16b8a309154135d167e71d0f9d2f0baede0f28ea3ef23405c38336fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "502f40bf16b8a309154135d167e71d0f9d2f0baede0f28ea3ef23405c38336fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "80aa3ee960c9f11572b0b9419bb84d7fb3a23ff4d409735f6cc1722517d818a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de0fc4f178177337c46b2af41519aface1f7531139784204afc52c03bdfaa1d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f449b32e6042615e42c7919c24cc22d7360b46de29f0a09ad9ec329e8231cf2"
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
