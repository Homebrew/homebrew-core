class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/v0.1.x/en/"
  url "https://github.com/rancher/rke.git",
      :tag      => "v0.2.5",
      :revision => "960d353a08dec21f56aacf7dd4112db9f70a8ecc"

  bottle do
    cellar :any_skip_relocation
    sha256 "84de2281959421ccf183627ceec16e60607bc641feea3a1e7bb4eba5b72bde28" => :mojave
    sha256 "c2ed019e36e9fc30a71ea635af8740d55071be0f459b8b93ef80d43b334d76b9" => :high_sierra
    sha256 "fdec559a612a3efbe1dee69a728f616a9212b07f716693156fbe02f50a4fb66c" => :sierra
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
