class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/latest/en/"
  url "https://github.com/rancher/rke/archive/v1.1.7.tar.gz"
  sha256 "f50c3f4464b8f20feed476abe7673becc9f7f233b950418ffd04728c9acc28a6"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "ea674cbdf294c7f8491197f25bbb28e8e010b03883cd684822dcadce7bc813c2" => :catalina
    sha256 "5333362ded3968be053f61fff8761a80584a7ee271056b056e0c9353b440a532" => :mojave
    sha256 "cf004727f0df70346d430e2bac32b0a61cc8e7334faf0b17b6f04b57d31a7b04" => :high_sierra
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
