class RancherCli < Formula
  desc "The Rancher CLI is a unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/v2.0.0.tar.gz"
  sha256 "3c7281efb5dced04588dea2b943ebbe0cb5b1621eeea97f6c477713d79c7c1bc"

  bottle do
    cellar :any_skip_relocation
    sha256 "3f1d28dfc5fe2072a7f850cae61edde59b5ba57ec673a249a8d9d2eb7942b583" => :high_sierra
    sha256 "25524f27dd0b9de57f3852994813ad9ff2b751b6602692dedc4396597c6aa8f3" => :sierra
    sha256 "6152818bc0906b12304aad3396428781052d3aedebef9031c58786520d5b61f9" => :el_capitan
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
