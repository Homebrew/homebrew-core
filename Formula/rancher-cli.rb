class RancherCli < Formula
  desc "The Rancher CLI is a unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/v0.6.9.tar.gz"
  sha256 "9c02a8fcfb9015587a5f1cb1d478e20c1a1e49b491db6878e43eb384b81b713c"

  bottle do
    cellar :any_skip_relocation
    sha256 "b54072cb8f1b635e876dc16a0c7d0bac61ae04672e6ba5ec769bf965bd088c2d" => :high_sierra
    sha256 "a0de2bcca3454fe74d085b2e9e55389fff549d0e6cd1486927a2116ff57e4450" => :sierra
    sha256 "e24b894a33b68272ee707652eea6beab4bf9a4d75186876979943402af77d085" => :el_capitan
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
