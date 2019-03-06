class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/v0.1.x/en/"
  url "https://github.com/rancher/rke.git",
      :tag      => "v0.1.17",
      :revision => "d09d6b6663d55b395e1632b491f6108422256591"

  bottle do
    cellar :any_skip_relocation
    sha256 "0dd91b8b2459cde3f57e52ef68ea9c4e193f7e94872fe45be7bb3336aef419f6" => :mojave
    sha256 "cfd4d059eff108256fee3263c1cb3b7d984f72211ef9fe955e9bbd0495b370c8" => :high_sierra
    sha256 "507d527441a9927b2e044edcac925b5b4745d9e5706e5a2fcdab73c394c8dbc9" => :sierra
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
