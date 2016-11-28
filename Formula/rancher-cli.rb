class RancherCli < Formula
  desc "The Rancher CLI is a unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/v0.3.1.tar.gz"
  sha256 "156594c7dcf32dc1801d42d2f79f29ecd0d1c962adb654b5cf7fbda9126537ae"

  bottle do
    cellar :any_skip_relocation
    sha256 "32203ec90bb63019e7590db8d90cca0c34ce46d0a8dbb8a469a462601f89db93" => :sierra
    sha256 "b84923f0d5b31fe8e5979762c2a3144593da33c2d3e634b788b0734e6517f18c" => :el_capitan
    sha256 "5a81b67db4c7551651ec9a3c7c8b9eff4320f53a2e7dd3d2a6ea65defc0ebd2d" => :yosemite
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
