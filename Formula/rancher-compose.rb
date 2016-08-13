class RancherCompose < Formula
  desc "Docker Compose compatible client to deploy to Rancher"
  homepage "https://github.com/rancher/rancher-compose"
  url "https://github.com/rancher/rancher-compose/archive/v0.9.0.tar.gz"
  sha256 "e49a711eaee301b8cb1028dee6be50a4041ded1db2f01fc9506bbde80bd1006f"

  bottle do
    cellar :any_skip_relocation
    sha256 "4cb3e9bb511c5c36c567fb755dadea4a568750b65a2b4f69f6fe4fea443792dd" => :el_capitan
    sha256 "8e2a932842844b593b09d84a4649bb9a4b2a032ad3a564227c43c061694115c7" => :yosemite
    sha256 "d4b560fc96637c4a0e504abcbb50eb048299a61ecc5789943044c767929523c6" => :mavericks
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
