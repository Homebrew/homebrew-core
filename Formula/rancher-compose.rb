class RancherCompose < Formula
  desc "Docker Compose compatible client to deploy to Rancher"
  homepage "https://github.com/rancher/rancher-compose"
  url "https://github.com/rancher/rancher-compose/archive/v0.12.3.tar.gz"
  sha256 "37af26f28d96301c0e1813c0c3dd0078573a5902bad5d7c449f0a4857afcb93e"

  bottle do
    cellar :any_skip_relocation
    sha256 "78344dea5f79d93b8d1a3156544d68865316ba5fa30a623f8abaaa8a03612bca" => :sierra
    sha256 "71323be798d099e44e3dde836a050f6389d532edf4dedb22daef769c39324448" => :el_capitan
    sha256 "91b9780007f50baecb622a78190a78adae7bde12f68ae2e9d2f7a3e87c4aa505" => :yosemite
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
