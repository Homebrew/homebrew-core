class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https://tanka.dev"
  url "https://github.com/grafana/tanka.git",
    tag:      "v0.11.1",
    revision: "e5556f1c851bcfe2f0ec885896642d7c418c692f"
  license "Apache-2.0"
  head "https://github.com/grafana/tanka.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cac3a49d6223ca9e7ee55cd7331d5bc227bb371876a3b105b7d1a5a0487b632c" => :catalina
    sha256 "06afffd99e5be5aa8ded8b3e8eaf878136f49c1aae42c25ee12538fa1eb3533d" => :mojave
    sha256 "5e883f815cf7e591ea9cbb50074fc01b2d8ec16aae69d6e8683c451a742ea36f" => :high_sierra
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
