class RancherCli < Formula
  desc "The Rancher CLI is a unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/v2.3.0.tar.gz"
  sha256 "784367268b09eab51ab472fbcb0f643490699e8cd21e06c94c0fc017065f9dbf"

  bottle do
    cellar :any_skip_relocation
    sha256 "88afc29ccbe080da761bee57ee5b80c1a1f300cba13447b87c0cad577ad349bf" => :mojave
    sha256 "1cb11955d2e394ae1732c0444b2de52c5a1d91252761e0e0b26f55f972a52b81" => :high_sierra
    sha256 "9038728e3401099e6b8c2ee9f3843b4c476180e939425c3ffd20b9bbd64b47dd" => :sierra
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
