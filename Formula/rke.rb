class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/v0.1.x/en/"
  url "https://github.com/rancher/rke.git",
      :tag      => "v0.1.13",
      :revision => "0b11a32935418664be3757d8adaf10e9a5666afa"

  bottle do
    cellar :any_skip_relocation
    sha256 "5f3198954212d9592973fe09e0c897edf25790e2f39519d7c2e4c542eb5a919d" => :mojave
    sha256 "beb97422bce1a8dae494e4e981e383d8786adaf3b32215667b9edc20967a0b7f" => :high_sierra
    sha256 "cfeaedad890402e5ea0539e167f9d6b3f6409c016227719f248467db95b4ea55" => :sierra
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
