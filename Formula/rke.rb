class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/latest/en/"
  url "https://github.com/rancher/rke/archive/v1.2.2.tar.gz"
  sha256 "c64d6616a6fe65ad0ef1cd65bff98145cbc4d1414377e500770638e5fccd83e1"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "2b587ace11fd9da4e89b0c8d5eeef74be44b704b8ba8ce36063c63ac7549d04f" => :catalina
    sha256 "e5acd0541a8ef8d5c1fc537e39681899d1b4dc1cb73c8044672df4e9f874f6fb" => :mojave
    sha256 "d67fc70db1bca4a2472d13481638da108e77c0f2fe1570579314502a1d6e221c" => :high_sierra
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
