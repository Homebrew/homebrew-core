class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/v0.1.x/en/"
  url "https://github.com/rancher/rke.git",
      :tag      => "v0.2.6",
      :revision => "14fa77df0d3f438f668451122dc9c082e5ce785d"

  bottle do
    cellar :any_skip_relocation
    sha256 "a4679b237497ba7e5f65803b66572eeecc16b3805cb15a052a8c7d73fbf766c4" => :mojave
    sha256 "7676d1ee185cf4cc53f5e0c0d2a4d3e7aea139e3e004b8e66ccf1261b89b946a" => :high_sierra
    sha256 "b32bb41639595699a75aec9d65a20306432b007293cc37802b7f45e208375c92" => :sierra
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
