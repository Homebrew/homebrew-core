class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/latest/en/"
  url "https://github.com/rancher/rke/archive/v1.3.1.tar.gz"
  sha256 "bdd8d79214544a4f2e262746b518b4f7f26352b94c63578fe1b582f6079b7462"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5650ea5362d51bf6f0ce57ed6af90a270deb2556a6bbc08c37516b2a5d3fa417"
    sha256 cellar: :any_skip_relocation, big_sur:       "4b35e68b991c426289eb36312e62b9819a98c38ba73d3bb53f91993c51578448"
    sha256 cellar: :any_skip_relocation, catalina:      "3237d3b70159e54b8a0fc21c3a8eb7548432910c2c8ded4a11ae005b34382454"
    sha256 cellar: :any_skip_relocation, mojave:        "fad78490683f8c204fe7edbd43d721f2c0de0e482cdf57e415f7e4a6f560c2a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d86d14268f383bf956342041d876ce13765d2cfd2d8403bb5c855d0baf4694f"
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
