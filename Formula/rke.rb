class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/latest/en/"
  url "https://github.com/rancher/rke/archive/v1.2.7.tar.gz"
  sha256 "b08a06523f8038d20a0704c94d23b9f56af577dd5a7325bbb478ca6057069b09"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7702fba58237783810daa524e5b590cf1548d3a3fa87726ffd10374e4ab49af4"
    sha256 cellar: :any_skip_relocation, big_sur:       "c0702e4fac931ca4e24475db287e7e21419ad6ac9acb63b8f836b0fcd4dc7e25"
    sha256 cellar: :any_skip_relocation, catalina:      "f20e08e222fbc795443fd5d7f4dffb932ab6053632bddd8c05c004632a93b738"
    sha256 cellar: :any_skip_relocation, mojave:        "65c10d74dd05ac34fe5cd6f371a30e15308eccd85a054e49d46665b413b4aaca"
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
