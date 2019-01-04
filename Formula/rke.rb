class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/v0.1.x/en/"
  url "https://github.com/rancher/rke.git",
      :tag      => "v0.1.15",
      :revision => "88926e57647ddd89ea6ff92a25c4c77ad0e95c7b"

  bottle do
    cellar :any_skip_relocation
    sha256 "10bfcced923dd2503110d84dc0aaeb006f895e0f32581df46647d45e0e08ab87" => :mojave
    sha256 "fffe8af74aff19f07cd797393ae6f836450e1d4c42166cd4aa7233e2ea8efef2" => :high_sierra
    sha256 "1ea3fd408afb94e398b3c95e099ad2367a56381ac8b30443e6d2c804391dffa6" => :sierra
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
