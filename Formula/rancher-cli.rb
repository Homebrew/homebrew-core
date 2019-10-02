class RancherCli < Formula
  desc "The Rancher CLI is a unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/v2.3.0.tar.gz"
  sha256 "784367268b09eab51ab472fbcb0f643490699e8cd21e06c94c0fc017065f9dbf"

  bottle do
    cellar :any_skip_relocation
    sha256 "713193e1ef71643163efdf54278aff7c0d89ebfa885b879f047146aef8c715ea" => :catalina
    sha256 "a59a2809bbc13f9ed37b130be216671199e0f3b63b795b2c9cf4beca4a19f142" => :mojave
    sha256 "82678c514123aab93a04f90902f903bdcde087a1a6a1e83d7ecf7d0304a6a230" => :high_sierra
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
