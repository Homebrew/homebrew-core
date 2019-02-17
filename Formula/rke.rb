class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/v0.1.x/en/"
  url "https://github.com/rancher/rke.git",
      :tag      => "v0.1.16",
      :revision => "e987eed1422785bf8c50308b272c2289b2ea9db0"

  bottle do
    cellar :any_skip_relocation
    sha256 "01da5909cef8727c4425414271cf45d6371870c4c9cce6226d53fe3f900fe8e0" => :mojave
    sha256 "04f300f08a3f8a3f4f0c027cb47a0eb754fdb441cf4016c4f3f1d22c394ef34a" => :high_sierra
    sha256 "d1837881ce05b6c4efb1d1a432605cc94aa9012e0aeb52a0af1a6ad4db83d454" => :sierra
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
