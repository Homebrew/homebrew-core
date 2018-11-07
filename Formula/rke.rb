class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/v0.1.x/en/"
  url "https://github.com/rancher/rke.git",
      :tag      => "v0.1.11",
      :revision => "45d79aa3598a35196fbb4472e2e5eac86172cff5"

  bottle do
    cellar :any_skip_relocation
    sha256 "be1fced3aca5af994b7bdea1a4be26cf35dd3504faff7c6cb03ca6baa78ffd34" => :mojave
    sha256 "056f55ac6c5debf8a6bc9f40d0870a510609fd514fee5e57f682057cd270a1d5" => :high_sierra
    sha256 "069d35aa9bcdaebe8116a59e78c86a61291ae21c93d66d6003a24c11b9e309ca" => :sierra
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
