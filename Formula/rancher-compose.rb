class RancherCompose < Formula
  desc "Docker Compose compatible client to deploy to Rancher"
  homepage "https://github.com/rancher/rancher-compose"
  url "https://github.com/rancher/rancher-compose/archive/v0.10.0.tar.gz"
  sha256 "cd35336095d9ea2bbdd7f780ae8b195ca31e2a0deba8ce451697ec2ba9e88566"

  bottle do
    cellar :any_skip_relocation
    sha256 "3dd91cd8c2d4f030eef61a892f4496da968314cb5e00b861976635098e087ffe" => :sierra
    sha256 "bd245ce7453d356e838dcf758fd6163dfb056c7a7a52a586c91ce2321180e3ce" => :el_capitan
    sha256 "46b7df3b44ee8454497ddce5deae61985d8ba2d514db82e8ebe3d3743fdce3ca" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/rancher/rancher-compose").install Dir["*"]
    system "go", "build", "-ldflags",
           "-w -X github.com/rancher/rancher-compose/version.VERSION=#{version}",
           "-o", "#{bin}/rancher-compose",
           "-v", "github.com/rancher/rancher-compose"
    prefix.install_metafiles "src/github.com/rancher/rancher-compose"
  end

  test do
    system bin/"rancher-compose", "help"
  end
end
