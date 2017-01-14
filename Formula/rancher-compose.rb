class RancherCompose < Formula
  desc "Docker Compose compatible client to deploy to Rancher"
  homepage "https://github.com/rancher/rancher-compose"
  url "https://github.com/rancher/rancher-compose/archive/v0.12.1.tar.gz"
  sha256 "84ddebcaa3196427a919643277e9d40d120ef58bed1c638bdbe53cfd0f29a757"

  bottle do
    cellar :any_skip_relocation
    sha256 "675f74f10e8e607801ab6eb0c8b088fce02a2c779ba722329d8a8d6ebff58de5" => :sierra
    sha256 "842d2f291e0ff7a3ad402a21c70f7c9a6a98bf3f3c96bcc9d58954dbe08aee71" => :el_capitan
    sha256 "3c6cd3f9afa50c6fee60394020d6ddcfd6a726d8c7bea6dc7bc7294089cc3bc0" => :yosemite
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
