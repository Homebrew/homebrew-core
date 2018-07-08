class RancherCli < Formula
  desc "The Rancher CLI is a unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/v2.0.3.tar.gz"
  sha256 "f806581989e96d13c18813629b3582684ee0ceeb8f4d8cee94b0b78be1c8a67f"

  bottle do
    cellar :any_skip_relocation
    sha256 "6c152b8f2963cc3ce73f80607048b1280144be09947e3222935155017debf9ee" => :high_sierra
    sha256 "0400507273625247fc2b60a71f5fc8b21b7ab7b5e9a39a832f030bc42d7930df" => :sierra
    sha256 "4e7878cc5419f3e25bfc4fd3cbe50e1247fbc2cf0a55bdbd16996b20fce9fb83" => :el_capitan
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
