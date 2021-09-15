class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https://tanka.dev"
  url "https://github.com/grafana/tanka.git",
      tag:      "v0.17.3",
      revision: "8b680de501685b534efba32a07dea408454bb73b"
  license "Apache-2.0"
  head "https://github.com/grafana/tanka.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ec250c0238fa90d722aee8fab529e75ab9bfe19a3ca88436a2159b7c0443fe1b"
    sha256 cellar: :any_skip_relocation, big_sur:       "5aa62b8e02f94262f35e05624eee0bdb5fc615baa74a3865f4a8ba98c1b4065d"
    sha256 cellar: :any_skip_relocation, catalina:      "d50845c84a6cc562ecbe48d041b1953e645e4d2eeb80a2bd25788bc79e26ef3a"
    sha256 cellar: :any_skip_relocation, mojave:        "b0adaab9a8ad7a79edbfcd96e14c69f5cf34e94259e67a874c8df5fb917e9971"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26572efc411e7aca443a2eebff7ee346cb566e82bc3798d689e63cf77993040a"
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
