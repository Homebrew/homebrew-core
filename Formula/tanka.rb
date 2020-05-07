class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https://tanka.dev"
  url "https://github.com/grafana/tanka.git",
    :tag      => "v0.10.0",
    :revision => "7f5f485a411aa08752fd6ed4847c8013e95f92d1"
  head "https://github.com/grafana/tanka.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d3005e8323875d7daaa31a8c035198bc7c50c7102d82a12058f08d17cdf459de" => :catalina
    sha256 "856493555f7da9fa5cb04a560a7ec99464b295bc790cb731efb35fe8bb05b988" => :mojave
    sha256 "2ca310b05a3bca4177f7195db45acf3b685c1a5ef28b9668ff971fb4637236ea" => :high_sierra
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
