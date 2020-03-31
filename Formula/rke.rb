class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/v0.1.x/en/"
  url "https://github.com/rancher/rke.git",
      :tag      => "v1.1.0",
      :revision => "ee820f55a93215e460a8ef2201b94a8f741c8e8d"

  bottle do
    cellar :any_skip_relocation
    sha256 "bc5d4786b1ce75056fd235cefb9318640708a2f05c7b7fabc1a06d1b510b0332" => :catalina
    sha256 "747d2ab296fe8589ff6177f728929060c229a0e2e8d7de6615c551867b7d6ba8" => :mojave
    sha256 "efb117642862bf0912024b4d39205963466c826a4b98221a99134c5eb0dcc0a2" => :high_sierra
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
