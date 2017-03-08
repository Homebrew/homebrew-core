class RancherCli < Formula
  desc "The Rancher CLI is a unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/v0.5.0.tar.gz"
  sha256 "c126fd29834e3f99de7262eb455d3c318cb8d1f602c13f702023d38a9059fbb1"

  bottle do
    sha256 "13a3be987a2e2a5e9c05f32dc676cb0267f94f90ef7d124297b6c5047e364885" => :sierra
    sha256 "7e722a72ac35dd3ba4f501d32287269696e51a2816df7f056cb5cc29e08ab4c2" => :el_capitan
    sha256 "eedfa1fc0a6bf3a3d12c9bcd23de40712a1f8f0a6cfbaef2713aa5ef6a67e1c0" => :yosemite
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
