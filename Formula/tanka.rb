class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https://tanka.dev"
  url "https://github.com/grafana/tanka.git",
      tag:      "v0.21.0",
      revision: "68d625e128b2678996ff442c385f5361c7987491"
  license "Apache-2.0"
  head "https://github.com/grafana/tanka.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "511588e4612c004220dc8f2546b006ef73fb9ded63e95e19384cf2e25d609fb0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8235fa81c47354a894bed3a6a42bea0e8b2d40850ed98c9f1ad23726ad20b0b0"
    sha256 cellar: :any_skip_relocation, monterey:       "a90d4c6e816075567a8ace1ec0c150187853b92a2909a964f7f3383af56f5449"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd722d5878ffd54481f007134afdf5cbee2fb438b581709618de8c225c94f386"
    sha256 cellar: :any_skip_relocation, catalina:       "9e9c73cbf0cdf1b8c473ecd96d98fd26f4038ba03d5a22ee6dc92f4bfe7c10ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "716f7ff0ebd661b7d04401a8f3507f730d66b0fe97e0962300b9397252d58471"
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
