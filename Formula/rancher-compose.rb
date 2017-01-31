class RancherCompose < Formula
  desc "Docker Compose compatible client to deploy to Rancher"
  homepage "https://github.com/rancher/rancher-compose"
  url "https://github.com/rancher/rancher-compose/archive/v0.12.2.tar.gz"
  sha256 "5b9311479eac85f4a0665258b4e1859e7b5eba3cbae66eb7c6864c59ff78d806"

  bottle do
    sha256 "6a7b98ec52f3ddb0987eefd85f3c994295cc805b41e493bf6233cd705005999a" => :sierra
    sha256 "f1a53710d2f225f79ada6ed41c2d16ae7a4fe856e5c181b77fd733f4881a9763" => :el_capitan
    sha256 "692a4b3dc5478398bb283c02d5b7ecd350b5488797c6a0300e5b922a23564c56" => :yosemite
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
