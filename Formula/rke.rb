class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/v0.1.x/en/"
  url "https://github.com/rancher/rke.git",
      :tag      => "v0.3.1",
      :revision => "50c252656ac7c6edbb678cab9ba9b6bc6d5da732"

  bottle do
    cellar :any_skip_relocation
    sha256 "266553319dc1a7ee6812f2331f90a87035f84eda5a5164ca0bcd547b161d8651" => :catalina
    sha256 "103ad00656e11c00a7f174ba2288ffc02d76c72281c49c534adf12d5d2e63b59" => :mojave
    sha256 "ff2823f207fd985f4c9c3bf8bab5e72c01b78b78bc17fca0ee8b99a1ce93a7f8" => :high_sierra
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
