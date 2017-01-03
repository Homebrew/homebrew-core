class RancherCli < Formula
  desc "The Rancher CLI is a unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/v0.4.1.tar.gz"
  sha256 "9eff3243135d5da8c03659ec6910989f418938d3346b9737052cb0b2a400196e"

  bottle do
    cellar :any_skip_relocation
    sha256 "e066b44b4d5558aa8f1774a8260391217bcf8e8e00b198bb21974db6e593c5bb" => :sierra
    sha256 "5d8cbf68f7c83d0b47369f7ed7880b787fe54a90b4987d2f93d81d51d290391d" => :el_capitan
    sha256 "bf4d56b782d4545a216d8da0807804a3d9ae1042e0b36da74d47346d050ce1f1" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/rancher/cli/").install Dir["*"]
    system "go", "build", "-ldflags",
           "-w -X github.com/rancher/cli/version.VERSION=#{version}",
           "-o", "#{bin}/rancher",
           "-v", "github.com/rancher/cli/"
  end

  test do
    system bin/"rancher", "help"
  end
end
