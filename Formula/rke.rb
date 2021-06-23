class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/latest/en/"
  url "https://github.com/rancher/rke/archive/v1.2.9.tar.gz"
  sha256 "958f1be715be516bc782896d6d77b0665054ec6545f94d1b423f24edec1a77f0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "54083beed14c0c861225d9ab0699e7a66bfe7b6777a5e4c30d49af4c15eab8b7"
    sha256 cellar: :any_skip_relocation, big_sur:       "78c70c924911a86b00ecbc11fb2e154641b12014fb267282a67d2ab26ebe40ac"
    sha256 cellar: :any_skip_relocation, catalina:      "c0eeb73161d08e6e60c99e452d01544c4df218bc94270a5e644c3746e049fc87"
    sha256 cellar: :any_skip_relocation, mojave:        "5411e2062eac433bf89b2d4970284c8b2eaeca272816fa87e8dd378eed56ac3a"
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
