class RancherCli < Formula
  desc "The Rancher CLI is a unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/v0.6.5.tar.gz"
  sha256 "b1bba00318579aa88dd32d9a70c7be8093d7c06008dcf932e695d8399714eca8"

  bottle do
    cellar :any_skip_relocation
    sha256 "58159e4c41ff604b4d6858e41ce0036a457cb349d35cfbdbda51fb254e0fc81c" => :high_sierra
    sha256 "411d408aecb76203c25e9eb9e234479a4fb95d790fb51aa8df7534acb6531be4" => :sierra
    sha256 "eee698c01a39be2cc61f8b16866a6612b6daa54e342aeec9f5da71fa1c1d9c04" => :el_capitan
    sha256 "5665875eba8bed3f9738337d590066e165e64480720a95b6abfe02b1b401fa68" => :yosemite
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
