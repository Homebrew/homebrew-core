class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/v0.1.x/en/"
  url "https://github.com/rancher/rke.git",
      :tag      => "v0.2.8",
      :revision => "30c0ba4ce9b2012433b3b7d9c88a313cc66ba2d6"

  bottle do
    cellar :any_skip_relocation
    sha256 "fded12c494e51ebaf8ad7846872f74522e1d0d0f13ef22277add39d42f9ef904" => :mojave
    sha256 "975d9fcf4f2495b2cf498bc19aa0ea2419c87c80d1a4f0916460b8ec2419cc9b" => :high_sierra
    sha256 "22d6cd4c75acbe0fc30abde4494be20182d1ea41cd61595aac24334bce1d14fc" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/rancher/rke").install buildpath.children

    cd "src/github.com/rancher/rke" do
      system "go", "build", "-ldflags",
             "-w -X main.VERSION=v#{version}",
             "-o", bin/"rke"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"rke", "config", "-e"
    assert_predicate testpath/"cluster.yml", :exist?
  end
end
