class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/v0.1.x/en/"
  url "https://github.com/rancher/rke.git",
      :tag      => "v1.1.1",
      :revision => "65f946ae5c798577b282e8b3fd12974b41f43bf7"

  bottle do
    cellar :any_skip_relocation
    sha256 "ebb9ba284fb185e5dc454cbba5f6545fc0be87ae8a7f29c68bab432fc2ce164f" => :catalina
    sha256 "7cd316aee13bff172f744a20412e239aa7f3b3fb689ccab0b9ffc6a474097bf3" => :mojave
    sha256 "d7a214c68b4b01b5f2d8ead9ba64773d7e255e88f7daa7203296c1a46832e5b2" => :high_sierra
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
