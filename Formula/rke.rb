class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/v0.1.x/en/"
  url "https://github.com/rancher/rke.git",
      :tag      => "v0.3.2",
      :revision => "27708fd2a260c974af3335d11c2dc3cde79a79a8"

  bottle do
    cellar :any_skip_relocation
    sha256 "e5b2fca85df079ae2a14fdbb3f1865237512ad0a97b4a1d7a09bb77b2de4ee82" => :catalina
    sha256 "ddfd000c7f4117518ac3e5f69dc0a2b9b2026c2cda9eac9bbf736a9ea21a7a2e" => :mojave
    sha256 "12fa9742ab07dd8f404443380979631e1fba33ade10844e6201a52290761b275" => :high_sierra
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
