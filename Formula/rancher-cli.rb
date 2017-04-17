class RancherCli < Formula
  desc "The Rancher CLI is a unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/v0.5.2.tar.gz"
  sha256 "4b7bd71f9f23e465e61c1cd5fd97957fff3265fad6e90ca51c48322bede9108b"

  bottle do
    cellar :any_skip_relocation
    sha256 "dc6cf021fb3a26726af6872abd95211a9d33cc9fa93d61b2659736268d2ca340" => :sierra
    sha256 "8d5476574783a86d3f949e979119ec6030ad9e81ec0504a5d037882d49576462" => :el_capitan
    sha256 "1f90cf5bcd2f49ce13530c6928e3adf14712f4a98979e7d4f416b1485d960193" => :yosemite
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
