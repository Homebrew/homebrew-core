class RancherCompose < Formula
  desc "Docker Compose compatible client to deploy to Rancher"
  homepage "https://github.com/rancher/rancher-compose"
  url "https://github.com/rancher/rancher-compose/archive/v0.12.0.tar.gz"
  sha256 "0b2c606268823a803f626264935ea5554d645afe6d73646285d86cf6d7c34cb7"

  bottle do
    cellar :any_skip_relocation
    sha256 "39757cd1b55012e86b5400c0468da879db16d73aac8e40e71eef9472525c532e" => :sierra
    sha256 "7c032e628ff0bff04c357400ff17627cd3a76a4cacbe1abfcfef43002127a2ee" => :el_capitan
    sha256 "6cb31ddd19175415c0ce03b732e9e674f521f79c8d8835e69138861bf74611b2" => :yosemite
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
