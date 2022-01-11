class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/latest/en/"
  url "https://github.com/rancher/rke/archive/v1.3.4.tar.gz"
  sha256 "97d56fb2e0e8b221c36ab66559a84bd2a9af11f9b8d69c959bd9c9b9e57311af"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5dce8f51367033ce3c3d672ec4a28c42fa8e4a793a8023421639278036dfd11"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a4a02b4738598442619b9cc58e14e79fbbc96fdea1c6e14ac9a8397b6110ecc"
    sha256 cellar: :any_skip_relocation, monterey:       "58b1c045ad3c45fc80774e0686a1eca4acefad796ea794d2780d08d7f6d1c5f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ed119780378957572845efa89a8e72225887ba741ea724b3d42f2da9f32be8b"
    sha256 cellar: :any_skip_relocation, catalina:       "70d30110dc5e83b6c9debe8b0eaad27cfc91bdcbd40668b00d92d43371ed6a00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90abbb6233f843f453c46ab1846422ee08857a98d0d108975a7978e25ae69d3a"
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
