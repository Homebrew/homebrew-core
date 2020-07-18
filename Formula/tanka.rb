class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https://tanka.dev"
  url "https://github.com/grafana/tanka.git",
    :tag      => "v0.11.1",
    :revision => "e5556f1c851bcfe2f0ec885896642d7c418c692f"
  license "Apache-2.0"
  head "https://github.com/grafana/tanka.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f6a510b8eedb26c43c2a9bf45883bf1d4b690861fe65c5949ab8f330a7269aa7" => :catalina
    sha256 "4aed423fb5e06697f27df4b145498f5d477290845400e43e540faf809c9d82eb" => :mojave
    sha256 "34e4ec5a9364f12701bdedb164eca8ffc11776cb915d738e572e6679937a868e" => :high_sierra
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
