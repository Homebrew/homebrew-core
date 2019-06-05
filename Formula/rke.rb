class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/v0.1.x/en/"
  url "https://github.com/rancher/rke.git",
      :tag      => "v0.2.3",
      :revision => "bdde78287c87b221b5023ad3debe8796ba18dbb2"

  bottle do
    cellar :any_skip_relocation
    sha256 "097733d0591b9e3230b7a2702cd5cb0353eb6dfcd58dcaa083ea668fdda3370a" => :mojave
    sha256 "8292a17f4edfd11a3a499cb280c1d879af3af66420528f5a005774850faceb0d" => :high_sierra
    sha256 "540ad13f53e93d342d0a8c04fa9bc2e49071159ed1f39c435a9cf53acf0cc17e" => :sierra
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
