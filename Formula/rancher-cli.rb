class RancherCli < Formula
  desc "The Rancher CLI is a unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/v2.0.6.tar.gz"
  sha256 "09539d73f2c5d57702fd5ac6cdafde964d4e0e15508bf035fb471b0104a7db27"

  bottle do
    cellar :any_skip_relocation
    sha256 "50dda64816a91156537fa70b83f1a5a0ac123af011f11979d91c8f02bd61682a" => :mojave
    sha256 "f235a8d468ec0a5e718fcc3deadde6020d1671cf4f07e9a1f4332552cb5496db" => :high_sierra
    sha256 "5b7a3cabb637aebc1b35c7645cc17e99517cefafe43380939e15fde49cedeb10" => :sierra
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
