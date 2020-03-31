class RancherCli < Formula
  desc "The Rancher CLI is a unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/v2.4.0.tar.gz"
  sha256 "666e8cc507a88f5b98da1d86ca13d9cb85ebd14e979297c06e882ce3e99ddf1d"

  bottle do
    cellar :any_skip_relocation
    sha256 "8529a27ad17d294661b1ea1e2c4d2da90149681419aff1382a4cd802613c1dca" => :catalina
    sha256 "07140cb6d3b0208e53bb879fd8db1ffa2db5f9911835fb907f77d4b4b4d987a9" => :mojave
    sha256 "66297b3b6fea84eab42e5c568bcd433a9fa774e357e97b4ac278b61c6f60a50e" => :high_sierra
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
