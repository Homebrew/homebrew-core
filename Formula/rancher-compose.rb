class RancherCompose < Formula
  desc "Docker Compose compatible client to deploy to Rancher"
  homepage "https://github.com/rancher/rancher-compose"
  url "https://github.com/rancher/rancher-compose/archive/v0.9.2.tar.gz"
  sha256 "7fd855a48c107e8f14bfa28b2f40ad2ccfac2fdfb1116d58268c68268e620ee6"

  bottle do
    cellar :any_skip_relocation
    sha256 "856f576eb3b89e9f397745aab5df55e0fa5c5f696aff966ca62956896703469d" => :el_capitan
    sha256 "99bfe5132a6e78bef257752fe6af95193e006f6aa84470af02e751914b2c49d1" => :yosemite
    sha256 "d0809e0b40d79d9a8dbbb68c1099e42276be50f30d51b01f04a9b025319cfd3a" => :mavericks
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
