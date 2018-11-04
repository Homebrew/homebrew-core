class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/v0.1.x/en/"
  url "https://github.com/rancher/rke.git",
      :tag      => "v0.1.11",
      :revision => "45d79aa3598a35196fbb4472e2e5eac86172cff5"

  bottle do
    cellar :any_skip_relocation
    sha256 "d0957e28ce726f05a9b93d9783666dbc96f019e390169ddc8d1fb442f238148b" => :mojave
    sha256 "76928fb1e9a5d4f00dfafa66a66473abf3b653b0b8d7cb4f9e4d769f251336b6" => :high_sierra
    sha256 "18fc3e41b5ee58503dafb32f201cadeb4baaf57e41b6ffb31afa64c677fee426" => :sierra
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
