class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/latest/en/"
  url "https://github.com/rancher/rke/archive/v1.2.1.tar.gz"
  sha256 "f2f8a5909e4bc319b9f50cb9d77eb3227f32c460b458e4908043c9d6240cc2fe"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "f717bf9f9ea33cf4ff360f58364feda01812845640e0dbcea4bc2005ca898db7" => :catalina
    sha256 "d190b1323bccd59d2948519f404bbdda99de71fc95555ad735d7d595c9f9a6be" => :mojave
    sha256 "a3188136b1a051a256f826376ad4043c4426ea3d33046a67c51d49119bb81ef1" => :high_sierra
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
