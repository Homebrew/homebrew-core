class RancherCli < Formula
  desc "The Rancher CLI is a unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/v0.5.0.tar.gz"
  sha256 "c126fd29834e3f99de7262eb455d3c318cb8d1f602c13f702023d38a9059fbb1"

  bottle do
    sha256 "c126fd29834e3f99de7262eb455d3c318cb8d1f602c13f702023d38a9059fbb1" => :sierra
    sha256 "c126fd29834e3f99de7262eb455d3c318cb8d1f602c13f702023d38a9059fbb1" => :el_capitan
    sha256 "c126fd29834e3f99de7262eb455d3c318cb8d1f602c13f702023d38a9059fbb1" => :yosemite
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
