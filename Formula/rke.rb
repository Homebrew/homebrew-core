class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/latest/en/"
  url "https://github.com/rancher/rke/archive/v1.3.8.tar.gz"
  sha256 "4087a7e04a106dac40db3a84a61eed757e87ccac8dc792aeab4c328576099013"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5c2b790d05cbecd7c355c0d1e93357640063678e38c774fa53cda04d9a4920e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4fc9a86aa790cd73754fc8a1cec9e43a3887e5fcdc9fa8ea1925b8b222635987"
    sha256 cellar: :any_skip_relocation, monterey:       "503b438eaf97106209a9b2513afbb6d0b8d4bef3f0f5070f2d82fb586004fa9b"
    sha256 cellar: :any_skip_relocation, big_sur:        "0fa1bf72233e7b495c600386265deac34082fab41be4fd5ecd493b6de3510566"
    sha256 cellar: :any_skip_relocation, catalina:       "ddcd79fd26e92809cebd71bdde141261a358f23a58eafaca08019d7695cf670f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a89b0a47884b1b9a2fc35c91a969bc64334f6d3928cc157fc4a38da7c86e878"
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
