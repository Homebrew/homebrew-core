class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https://tanka.dev"
  url "https://github.com/grafana/tanka.git",
      tag:      "v0.16.0",
      revision: "774c664789e28909961750a7a23491974a521c1a"
  license "Apache-2.0"
  head "https://github.com/grafana/tanka.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7971b7f7c47003505aa3122d425bfda5bb8a6053f49685d48750b8f523f22785"
    sha256 cellar: :any_skip_relocation, big_sur:       "cef284c7e99f843c362a1832f1d82562039418e40e30d83f206e3ec3be5105a9"
    sha256 cellar: :any_skip_relocation, catalina:      "2149eedff8ed36c661a1c90523dd06adde44b6ac0b06b99412a4df4841069c64"
    sha256 cellar: :any_skip_relocation, mojave:        "4d379b005e87e6bd194c0f4ccd943349bbd9dd1876984cdace145c10c01e93d7"
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
