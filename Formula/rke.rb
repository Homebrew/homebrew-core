class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/latest/en/"
  url "https://github.com/rancher/rke.git",
      :tag      => "v1.1.3",
      :revision => "b3082ecb934e5761de9846d336b6a77350169368"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "9e32789bb442855f6012aa4b96a3d67ee315cdf0b8b851ceaa59a955f372e9ba" => :catalina
    sha256 "267e5bee1bc54be1c0f41336dac4b59f309fcf6cce836e0308c6c775eb4530eb" => :mojave
    sha256 "f98a5dbb85122f5dc8f0e33a377359b323b36447f9976eed94da0e0998f7a057" => :high_sierra
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
