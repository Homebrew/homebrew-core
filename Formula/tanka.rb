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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f744a4582aa42a9894676beb884d9447eca55052f0154e8723e894d835f23e0b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d5c2707e608317939161ca5d30838ea7bff710564c598d239379d986cd1b6661"
    sha256 cellar: :any_skip_relocation, monterey:       "1af841fb48ce0a9378429dace5ad386a71a2497980158ec75712bc852cd7f407"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb83c2ec32f12459b6b3cf7319e4d4c2c4e2ebb51e20a355fd8f9a9fe00dec7a"
    sha256 cellar: :any_skip_relocation, catalina:       "811b407ac01b08e403bcd13a9b4a0426056099a1d7f83babff1dcd11c9cfe9fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afda0edf8d7324157d32ba15dfdc369a0b3c884dd1d4f73b1293ea78acd8e174"
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
