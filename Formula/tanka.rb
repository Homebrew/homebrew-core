class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https://tanka.dev"
  url "https://github.com/grafana/tanka.git",
      tag:      "v0.15.0",
      revision: "014fae31d759c37ce1f21cf9ece1f7ce51fa28c1"
  license "Apache-2.0"
  head "https://github.com/grafana/tanka.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4c38ee4f904e18ea3d68c157ec9c9374868a453539c56ebc6587bb7ace282989"
    sha256 cellar: :any_skip_relocation, big_sur:       "49f0c4756478a459aa99cc8f67b17c596bee55969ce8d84a49721d7e95c8cf8a"
    sha256 cellar: :any_skip_relocation, catalina:      "162c1a253a67f26f4bc8926b0fe95766d919ab0012d4ae6dbe32012c9fb51602"
    sha256 cellar: :any_skip_relocation, mojave:        "45be6711fadccea634347e764816aba38c539d370e592c359a64fb7602d806ce"
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
