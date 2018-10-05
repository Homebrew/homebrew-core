class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/v0.1.x/en/"
  url "https://github.com/rancher/rke.git",
    :tag => "v0.1.9",
    :revision => "bff7e0a2c3b792704020263927fb7d49b55a3017"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/rancher/rke/").install Dir["*"]
    system "go", "build", "-ldflags",
           "-w -X main.VERSION=v#{version}",
           "-o", "#{bin}/rke",
           "github.com/rancher/rke/"
  end

  test do
    system "#{bin}/rke", "config", "-e"
    assert File.file? "#{testpath}/cluster.yml"
  end
end
