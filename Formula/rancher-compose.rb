class RancherCompose < Formula
  desc "Docker Compose compatible client to deploy to Rancher"
  homepage "https://github.com/rancher/rancher-compose"
  url "https://github.com/rancher/rancher-compose/archive/v0.10.0.tar.gz"
  sha256 "cd35336095d9ea2bbdd7f780ae8b195ca31e2a0deba8ce451697ec2ba9e88566"

  bottle do
    cellar :any_skip_relocation
    sha256 "3c830b4d3507082ca229e0003d7b0708fb64923b2216e40af2c1a1c3467e9a89" => :el_capitan
    sha256 "f477711ca47c9f469d1b6974171ae190252951b0b0ced8aa57e3df8b00e93d19" => :yosemite
    sha256 "758715db6f78ab8ed6692b7a43b6bf938fc228fdba92e5a32bae94d813ac524d" => :mavericks
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
