class RancherCompose < Formula
  desc "Docker Compose compatible client to deploy to Rancher"
  homepage "https://github.com/rancher/rancher-compose"
  url "https://github.com/rancher/rancher-compose/archive/v0.8.6.tar.gz"
  sha256 "720de0210943fb5217592aecec085bbbbd657111a036cb46c034e0008a136446"

  bottle do
    cellar :any_skip_relocation
    sha256 "662c401e194be2c8d088795e288d562cb88faa7327028c94a1fef6c79e53b48b" => :el_capitan
    sha256 "288cf7c2fcaeacbadcc2fe44e1a0e91df9f92b6174696aa8286706859356a59c" => :yosemite
    sha256 "83fa597f44fa6f5accb9bb8d3264b1c98dba8c923c93a3a1fc9057473526e715" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/rancher/rancher-compose/").install Dir["*"]
    system "go", "build", "-ldflags",
           "-w -X github.com/rancher/rancher-compose/version.VERSION=#{version}",
           "-o", "#{bin}/rancher-compose",
           "-v", "github.com/rancher/rancher-compose/"
  end

  test do
    system bin/"rancher-compose", "help"
  end
end
