class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/v0.1.x/en/"
  url "https://github.com/rancher/rke.git",
      :tag      => "v0.2.7",
      :revision => "8577148d8eec47c9a0ba2a374e28a8e95cb68c37"

  bottle do
    cellar :any_skip_relocation
    sha256 "94abe8039ce77b9ce9029465b622d877bffe98e19f15f6ee5ae7321754f1f51a" => :mojave
    sha256 "8b543d43a61af691bb8b7bec4bc4390ab4076020cc8f0e451ffaf1ee0a180cf7" => :high_sierra
    sha256 "20795f930c598a60eb7515a4f9de770b9062b5eb4be4141f87d42013b8e5f320" => :sierra
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
