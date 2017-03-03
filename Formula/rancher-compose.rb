class RancherCompose < Formula
  desc "Docker Compose compatible client to deploy to Rancher"
  homepage "https://github.com/rancher/rancher-compose"
  url "https://github.com/rancher/rancher-compose/archive/v0.12.3.tar.gz"
  sha256 "37af26f28d96301c0e1813c0c3dd0078573a5902bad5d7c449f0a4857afcb93e"

  bottle do
    cellar :any_skip_relocation
    sha256 "cbf5b16b07a957e23020854a3079bb4a74c4ce115daf5ca248c715544c03791c" => :sierra
    sha256 "e5d748cc7197bdb70a5a330028f65f645ac904845792610387196ef5277edb1d" => :el_capitan
    sha256 "3b8ce2d4b97376000dc4ef803a18a042032e7cb93f781ad5f25d7c429ce09530" => :yosemite
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
