class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/v0.1.x/en/"
  url "https://github.com/rancher/rke.git",
      :tag      => "v1.1.2",
      :revision => "cd9d26dc51b50ae7be47a9b7972fc09c128aa405"

  bottle do
    cellar :any_skip_relocation
    sha256 "485475e140893ca50c38cf623e0134efa262593fddd56bcf051c7c52422b09bb" => :catalina
    sha256 "661f160bb68863891f280840792b59de649c3629d5a690d516b2863f20ab1ed7" => :mojave
    sha256 "b496256743ef5c410e2cf879ea31c8ea663e89ec5ffd6cc61bc3b35026a63ba8" => :high_sierra
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
