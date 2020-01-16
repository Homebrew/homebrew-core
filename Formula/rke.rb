class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/v0.1.x/en/"
  url "https://github.com/rancher/rke.git",
      :tag      => "v1.0.1",
      :revision => "1c95f85c9f431bb9c21c5b8233a7294d38568280"

  bottle do
    cellar :any_skip_relocation
    sha256 "744e4cd4cbb3a59662ee91d91fcfbe3a8f49db35184dea76b23465e09202aaa4" => :catalina
    sha256 "c31a0059395e83af323873dea2c39bafd1bf53ce235c63413710fd7f02b7fcfb" => :mojave
    sha256 "5962ef1a891dad9db7a04d169425d0cf52d2c8a17fd154a00df11210252c60ed" => :high_sierra
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
