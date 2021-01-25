class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https://tanka.dev"
  url "https://github.com/grafana/tanka.git",
      tag:      "v0.13.0",
      revision: "291814d05e298c296a954d8912bce34796e17a3c"
  license "Apache-2.0"
  head "https://github.com/grafana/tanka.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9b470a925b2fb43d4fa08f7798bd3c5e0ce9ab54841d71f969c33af12f09f612" => :big_sur
    sha256 "a37f3718e66f5944930c4b7c0268f9e57c65a86327663080d438ef01fcd5c198" => :catalina
    sha256 "3b2759ab2b1f4c85543ca6badf31a60a2e6682037f8a4a88950bcd59efd2f532" => :mojave
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
