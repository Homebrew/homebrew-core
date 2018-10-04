# Documentation: https://docs.brew.sh/Formula-Cookbook
#                http://www.rubydoc.info/github/Homebrew/brew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Rke < Formula
  desc "Rancher Kubernetes Engine, an extremely simple, lightning fast Kubernetes installer that works everywhere."
  homepage "https://rancher.com/docs/rke/v0.1.x/en/"
  url "https://github.com/rancher/rke.git",
    :tag => "v0.1.9"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/rancher/rke/").install Dir["*"]
    system "go", "build", "-ldflags",
           "-w -X main.VERSION=#{version}",
           "-o", "#{bin}/rke",
           "-v", "github.com/rancher/rke/"
  end

  test do
    system bin/"rke", "--version"
  end
end
