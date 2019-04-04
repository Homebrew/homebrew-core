class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/v0.1.x/en/"
  url "https://github.com/rancher/rke.git",
      :tag      => "v0.2.1",
      :revision => "eebd7fbf215ef7ee97a953c6a2a01597371ced5b"

  bottle do
    cellar :any_skip_relocation
    sha256 "71cce91f3daeb36cc6aa36134fc6509e2b2a8d43c0bcecc682dc6f3bd26b4986" => :mojave
    sha256 "eb9e015ddc0c3b0d5aea412e6c8f3269cecbb45e6024e5e99c650a5d4871d72b" => :high_sierra
    sha256 "604cb94f11cfe015db62b429fdd129b559f900b11d71a3fd124a649cfdd455df" => :sierra
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
