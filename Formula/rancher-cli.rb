class RancherCli < Formula
  desc "The Rancher CLI is a unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/v2.3.1.tar.gz"
  sha256 "cc821f9d2e1c330e863a9e8724e03ac53f5bcac3c34debec959ad655a3007c2f"

  bottle do
    cellar :any_skip_relocation
    sha256 "fd25611f0a4055cba81a35c08dcf5813101b8bf1aa7c75b0911aacf22597c522" => :catalina
    sha256 "58d4537dbee30457b647aa705612c8114471054a6ee5bb2dc124c7c204c11d12" => :mojave
    sha256 "7bacb6d94cd3d5736ba3f8d3a67ae53a85ef0b57447724edeb2dcce12957d0eb" => :high_sierra
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
