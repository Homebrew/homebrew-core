class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/v0.1.x/en/"
  url "https://github.com/rancher/rke.git",
      :tag      => "v1.0.5",
      :revision => "40d8c7089a033dc7b14700f1cbc7c81d6bf876d6"

  bottle do
    cellar :any_skip_relocation
    sha256 "6050f68a0a81d7c8482559a5f20d62f2237becf53ae66339cf95d65137cfb50c" => :catalina
    sha256 "5989d6481016bbf7dce85ae573bab28cb3cfcd8b588b46c2b8689c130c8d8392" => :mojave
    sha256 "21bd27d09b5a1b54ecd612d8f075a01a4ff0140b82b681f99c55ac39e19f2ad6" => :high_sierra
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
