class RancherCli < Formula
  desc "The Rancher CLI is a unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/v0.6.8.tar.gz"
  sha256 "2a3b6b83d9e39f9ed090f342c40a1213c97713f87d8dab06249e169e7a4b7fc0"

  bottle do
    cellar :any_skip_relocation
    sha256 "48c9fd990fce859d293d6df2e3451dc7311905188eb9b5d3e2f0df0db15a8c0b" => :high_sierra
    sha256 "cffcd671d17426028ca181e8dc4c13deef49784a2b165d50d9cd74097892e22d" => :sierra
    sha256 "75cc2c8ad771c28e07cd88a022b9a028053c348530bbd02408f6af43cd262d6f" => :el_capitan
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
