class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https://tanka.dev"
  url "https://github.com/grafana/tanka.git",
      tag:      "v0.20.0",
      revision: "82ab8cfcef4c16b2de068a7bd4e0f54fa6f6df82"
  license "Apache-2.0"
  head "https://github.com/grafana/tanka.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9d911bed665758e48c286e82ad7d91598d386acfea942154ae31ab3481b2869"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cfe123733366bfab2b45192fd09ec103410d5e9747e71b6cf71da1e3fca26bf3"
    sha256 cellar: :any_skip_relocation, monterey:       "96275cf448692e8a02de72a5bfb2e0f15f1e12df10403e192d52faf91932bce4"
    sha256 cellar: :any_skip_relocation, big_sur:        "58d5f4ef2de1eed8d719bcc9f0ec73f28447f8feb45cacd88690b5291ab41734"
    sha256 cellar: :any_skip_relocation, catalina:       "76cb504b05cb6f9f8a99f517568dd8acf26e3b4631f1aac0f741c4a0b062e5c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38298f36688a96245473c6702aa4c47ef7cc5ceb28b57f652561c04013716c2f"
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
