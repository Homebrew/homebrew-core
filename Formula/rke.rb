class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/v0.1.x/en/"
  url "https://github.com/rancher/rke.git",
      :tag      => "v0.1.15",
      :revision => "88926e57647ddd89ea6ff92a25c4c77ad0e95c7b"

  bottle do
    cellar :any_skip_relocation
    sha256 "04dbd0cebe16c85d7457d0a769646bbec078090f843aef22a0889936e657fa0a" => :mojave
    sha256 "ab15387a57cd67fa81729d43abcd7d9cdf890cc3b3a4166fce3a54c02a10d505" => :high_sierra
    sha256 "30e818a89aa45417674fccc7e815f248aa1efe46a6a91538dbd60298926436b2" => :sierra
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
