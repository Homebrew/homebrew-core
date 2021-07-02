class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https://tanka.dev"
  url "https://github.com/grafana/tanka.git",
      tag:      "v0.17.0",
      revision: "3a1289b985301dc55bc24e95bcb1d3e1bdc2e825"
  license "Apache-2.0"
  head "https://github.com/grafana/tanka.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5fb5e4ce8e0de0975348b388a1aa733ffdaa6229c3ecc82f72a09e7d284d510e"
    sha256 cellar: :any_skip_relocation, big_sur:       "2a9a1d910f12bed853be8ecd4a7310ab1fb1d12d383e31d12972f624df15b7c5"
    sha256 cellar: :any_skip_relocation, catalina:      "c2a821902ac154d8b35d37f2d4f92fe89ddbc6d7efb3e1592817a375db60a947"
    sha256 cellar: :any_skip_relocation, mojave:        "c626f5fde34f278dedd1bef1a3402098314e3dcf98770702ef3820daeaf5c340"
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
