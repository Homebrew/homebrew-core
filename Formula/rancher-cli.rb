class RancherCli < Formula
  desc "The Rancher CLI is a unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/v0.1.0.tar.gz"
  sha256 "3fad04522eb4b689de191da6322907c79a6ef41b057e6cf34f1570ad0f58de00"

  bottle do
    cellar :any_skip_relocation
    sha256 "c2677bb7bbf186a91de2f10666501782ead142cfba61ac15820664c4d46d926e" => :sierra
    sha256 "5efbfee8af31b4fd64c585b47b894f7508b32471081240d14dcc81fff5256fe9" => :el_capitan
    sha256 "a68123c4addf99decda5869702210d7c0d455049e0a1b1545a6d40dae0cbafcf" => :yosemite
    sha256 "e53ab78248973a15f5dc0403e46aa96ce61407545f830d7d10b58d2b7ec26a78" => :mavericks
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
