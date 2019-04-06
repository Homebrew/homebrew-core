class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/v0.1.x/en/"
  url "https://github.com/rancher/rke.git",
      :tag      => "v0.2.1",
      :revision => "eebd7fbf215ef7ee97a953c6a2a01597371ced5b"

  bottle do
    cellar :any_skip_relocation
    sha256 "ca2eeaf2a9f73d80df85515b6845a8b18a55d742e493a41e35ce5af44d01f4a5" => :mojave
    sha256 "9e62206c5830d2ada5a93d693b96cebd1bb4755cb028c053321b10015265b7c6" => :high_sierra
    sha256 "51e919424df1b439b15d503d6a9aae389ea8e7c824c134ea4b6d3714129926d8" => :sierra
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
