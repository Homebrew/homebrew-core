class RancherCli < Formula
  desc "The Rancher CLI is a unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/v0.6.2.tar.gz"
  sha256 "10e6144b085e55db163ec6864a427b5335dc9a8326725d76d5bba84cd1e311fa"

  bottle do
    cellar :any_skip_relocation
    sha256 "12eb2eb8cd564a116bb6808570d4be1556ee70681d743841ae999b6a732096a7" => :sierra
    sha256 "f8f640fa6a2952dda27fe79a0806cea8c28476b453752220a36ff583d56b4aed" => :el_capitan
    sha256 "d14ff98048a8dda616dd908dfad5d21d201853cd92c3948eee5f1e66afb71669" => :yosemite
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
