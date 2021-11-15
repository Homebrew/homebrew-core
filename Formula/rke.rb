class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/latest/en/"
  url "https://github.com/rancher/rke/archive/v1.3.2.tar.gz"
  sha256 "532fb0751eb7ca9cf855e49e433d63fb760bdf8e131af3440744e792338f706c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d21e9bd629ea287cc1feb07a29b4c061549fd32fe88c47ff9c4e95fae7d901dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "04b2ae6f339c8975a2cf9ecb87f669ec7e16cd24e9ad9d5621f3879032cef86f"
    sha256 cellar: :any_skip_relocation, monterey:       "ef054c17f29bf1e95a322095763c510e374d4a532515255a860040d94bcdaa26"
    sha256 cellar: :any_skip_relocation, big_sur:        "f26b2441ed4e6d86cf7a58d5ba81cb1b4143105714a4408c28195e6ef618a6d4"
    sha256 cellar: :any_skip_relocation, catalina:       "1e10f4f4ea04cb9f6dedb6d7a12c53d165b8d281b4a5ad77b8a65157963d436a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f456c0eb40b4af83fcd688ce975e6c28d6057e6e178e9e39afdae362fac8f558"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
            "-w -X main.VERSION=v#{version}",
            "-o", bin/"rke"
  end

  test do
    system bin/"rke", "config", "-e"
    assert_predicate testpath/"cluster.yml", :exist?
  end
end
