class RancherCompose < Formula
  desc "Docker Compose compatible client to deploy to Rancher"
  homepage "https://github.com/rancher/rancher-compose"
  url "https://github.com/rancher/rancher-compose/archive/v0.7.4.tar.gz"
  sha256 "a0d285dd0608323c28a78782e85fbe3f52ddaad9d101030fad39efe3b20dadc9"

  bottle do
    cellar :any_skip_relocation
    sha256 "3af6309c9af3e30deb10bb7744c352a8b25f9b5136c0a38d81deb28ec360e17d" => :el_capitan
    sha256 "21559a34c86d1e4183336ba238651cc21f8c2ece3f78f4fcee006692b4f5751d" => :yosemite
    sha256 "e83229b6f65f27e197a7e8f3397b45d05ca57ae2a2129f8527c8ac66bf4dbf65" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = "#{buildpath}:#{buildpath}/Godeps/_workspace"
    mkdir_p "#{buildpath}/src/github.com/rancher"
    ln_s buildpath, "#{buildpath}/src/github.com/rancher/rancher-compose"
    system "go", "build", "-ldflags", "-w -X github.com/rancher/rancher-compose/version.VERSION #{version}", "-o", "#{bin}/rancher-compose"
  end

  test do
    system "#{bin}/rancher-compose", "help"
  end
end
