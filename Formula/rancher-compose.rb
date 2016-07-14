class RancherCompose < Formula
  desc "Docker Compose compatible client to deploy to Rancher"
  homepage "https://github.com/rancher/rancher-compose"
  url "https://github.com/rancher/rancher-compose/archive/v0.8.6.tar.gz"
  sha256 "720de0210943fb5217592aecec085bbbbd657111a036cb46c034e0008a136446"

  bottle do
    cellar :any_skip_relocation
    sha256 "d6c053ce3474479f1fa0f834627eb7b0d16825d42b056f162d14acdb5d4bd3aa" => :el_capitan
    sha256 "e4dbd18eef5f87d48a9e38f6a105abc85ecbe20ae5db97e4269e225a4a82dcda" => :yosemite
    sha256 "e2467027368d09e7b0ea1243db21ed210e73bdff956deb81a4cf5ab2ef751a41" => :mavericks
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
