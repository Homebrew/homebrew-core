class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/v0.1.x/en/"
  url "https://github.com/rancher/rke.git",
      :tag      => "v0.2.2",
      :revision => "479f315278a47b846d14db79e23c18ab62d7d52a"

  bottle do
    cellar :any_skip_relocation
    sha256 "d26a87a3faf94f16da808f0f133bb7a6560846b53c8e2058504c03522c9db9b5" => :mojave
    sha256 "51c3641dedaaec277a005dcd1bfca3e73fb7bee37492e7360a7ce5e3abb37e4b" => :high_sierra
    sha256 "c638e82372f31fd465b59b23b035aa8a97c0f5eedbe02492ee456c396ddcb3e6" => :sierra
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
