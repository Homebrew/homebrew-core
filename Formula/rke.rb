class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/v0.1.x/en/"
  url "https://github.com/rancher/rke.git",
      :tag      => "v1.0.4",
      :revision => "9fa5ca6cdb1b5f82ae967d4be4a77e253ed63d8b"

  bottle do
    cellar :any_skip_relocation
    sha256 "aa7bd908c0d60289f745e43c35ec6f9e616be65dfb1276abd7593cb9dacf05c2" => :catalina
    sha256 "d4937c2a438c09ab9cd7f086d0ceeb0229aa3c8f46520dee22f49daa11165ffa" => :mojave
    sha256 "e0953a3e33636182dd5f945fcf1e2c5066cf94c871bb027247a9201273d5cf5e" => :high_sierra
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
