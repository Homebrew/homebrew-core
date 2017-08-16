class RancherCli < Formula
  desc "The Rancher CLI is a unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/v0.6.3.tar.gz"
  sha256 "c988be39dfa783a61ae8ccd412e6e23e3df2582d9462faf916c68c5666a7e00b"

  bottle do
    cellar :any_skip_relocation
    sha256 "d8e928d6051efb61473fb2b63c567563dd4daba272d43f321158d87a6bc4fbc7" => :sierra
    sha256 "db816084e0b512beb07b78ab411a3bd7585c7820a65da0ffbd1c683e51b0b810" => :el_capitan
    sha256 "48ad683bc64c9850612bc9f1ba32cbd677dd6b634b168c5a0da1ec5d4e321cd0" => :yosemite
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
