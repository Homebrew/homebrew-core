class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/v0.1.x/en/"
  url "https://github.com/rancher/rke.git",
      :tag      => "v0.2.7",
      :revision => "8577148d8eec47c9a0ba2a374e28a8e95cb68c37"

  bottle do
    cellar :any_skip_relocation
    sha256 "4e0e7e909bfedec2644d70f5da224ccc1cead5d3e4539cdb78bfd9f09fa86c18" => :mojave
    sha256 "48b8aa75b6bd3ca471db524176cb74f818b51d524f64f7bc81ae3a60a133cf6d" => :high_sierra
    sha256 "2b698b50398a150d009aa7855fe765a452ec4773fd347cea3dba179441d81829" => :sierra
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
