class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/latest/en/"
  url "https://github.com/rancher/rke/archive/v1.3.8.tar.gz"
  sha256 "4087a7e04a106dac40db3a84a61eed757e87ccac8dc792aeab4c328576099013"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "624d3fb1fb11ddc6265d594cf8bf005d29739259ed39ef108f02e1a6ef65c059"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b897ec23aba479db91b2671b79cf388c3abe4c880bc3968752f372b61994ee05"
    sha256 cellar: :any_skip_relocation, monterey:       "cf18bc2c8836aa040a6f21b4151a00303d8ec886a38c0fea0d2a9808d73e3eef"
    sha256 cellar: :any_skip_relocation, big_sur:        "831b8911551e0e7edffb15a0d32f37d8efeef8262335226054f0b2de9bd5947d"
    sha256 cellar: :any_skip_relocation, catalina:       "c1fe4e26bf731d9cf365e26f1ce01d9baefe554727a48621873a89e51f75dc90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ad70f4ff63c2bc6fc724e814d64fb4ec0dce2c8ea890ccf91d1b8abfa0bd4a4"
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
