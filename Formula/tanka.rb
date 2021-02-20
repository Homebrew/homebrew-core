class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https://tanka.dev"
  url "https://github.com/grafana/tanka.git",
      tag:      "v0.14.0",
      revision: "4b00e2b824c3b113557fd092601b65dedf507fed"
  license "Apache-2.0"
  head "https://github.com/grafana/tanka.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "f07de82a23882bb5f3e70ce75af636ac8531a1dad3ffff9d6c3e1bff2477e48d"
    sha256 cellar: :any_skip_relocation, catalina: "a623c5125bfe60bd68f2ce905a1181a16a1307ad9eefb058128ac7d5e34a0b87"
    sha256 cellar: :any_skip_relocation, mojave:   "e05cfb512827a94bb0d8303a32737ff0da0fe63f5d44a49603b1d5d39d3ae264"
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
