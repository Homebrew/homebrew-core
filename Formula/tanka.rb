class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https://tanka.dev"
  url "https://github.com/grafana/tanka.git",
      tag:      "v0.23.1",
      revision: "e53e74b26e14cfcb320602badb471d0c34a24155"
  license "Apache-2.0"
  head "https://github.com/grafana/tanka.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19ebc6c6a40455549d84339e13956678d2276a0791512e52389bee866829b493"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "924468a521b5334d2b9e9c7016dda2a91e58adbf8b09ae1d48373edc926d5174"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "924468a521b5334d2b9e9c7016dda2a91e58adbf8b09ae1d48373edc926d5174"
    sha256 cellar: :any_skip_relocation, ventura:        "298086067176aa6b272285f5d66c54ec3b57ca939f9efb2e226c3864e195436d"
    sha256 cellar: :any_skip_relocation, monterey:       "dd7b67cab0598b62c26ce1101fcb4208d0ded91760780cecef88e38e472d0dc6"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd7b67cab0598b62c26ce1101fcb4208d0ded91760780cecef88e38e472d0dc6"
    sha256 cellar: :any_skip_relocation, catalina:       "dd7b67cab0598b62c26ce1101fcb4208d0ded91760780cecef88e38e472d0dc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38df5c3af8e10af2e9cb5d723d86527ddc04240de2265e5e780258b8927d2e6d"
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
