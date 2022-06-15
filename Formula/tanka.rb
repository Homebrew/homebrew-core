class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https://tanka.dev"
  url "https://github.com/grafana/tanka.git",
      tag:      "v0.22.1",
      revision: "ed87b3829074f6b26f62cea7ee190a43b910c4ec"
  license "Apache-2.0"
  head "https://github.com/grafana/tanka.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "699b18dd578b80cf0fac9534a09628fcd44fbdf1ed289d7dff677f510e2eb72d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb3f459d323cefe7d2b49ea42d9bf20f3bbc273be0c3cba62f18fa2c0071bea3"
    sha256 cellar: :any_skip_relocation, monterey:       "f369b3ff08d81289c6c0a5bf2884c9537b1d44eb9e1c2e668bfc0c0b2f23f8ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "960c7a4ccd94a0619c04c19ee59c0745c2e07af08c77b8ae3b29fa0e149f933d"
    sha256 cellar: :any_skip_relocation, catalina:       "efa1a7e55f3dc4c03268b43379284d19ad14bfb494fc5e5ea875e7b1cc60e977"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c9e24c3a006d6d7dcd76d0509120b7fc6c0242c234d5174cee514f2145baad5"
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
