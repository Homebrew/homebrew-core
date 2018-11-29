class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/v0.1.x/en/"
  url "https://github.com/rancher/rke.git",
      :tag      => "v0.1.12",
      :revision => "2baa7c73394e3f11279195bad1b204d57d9031d5"

  bottle do
    cellar :any_skip_relocation
    sha256 "c934b887218caa7e8dfc521dcfb1b9b04e55271afb5ef911bfa1b43879b83f32" => :mojave
    sha256 "534285ec435392bed6edd73efb7699473f259cedcebb197d531461ee99279d37" => :high_sierra
    sha256 "1d70584f0dae747f6a4864d07b3a6d43f4ab53601e6a6eb55c0b6b23d58f9cfa" => :sierra
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
