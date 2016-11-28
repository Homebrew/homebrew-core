class RancherCli < Formula
  desc "The Rancher CLI is a unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/v0.3.1.tar.gz"
  sha256 "156594c7dcf32dc1801d42d2f79f29ecd0d1c962adb654b5cf7fbda9126537ae"

  bottle do
    cellar :any_skip_relocation
    sha256 "ad919767a6bcf0a8a765b544a555aaf46f1e4274a539753c6663b0de1e61c6c5" => :sierra
    sha256 "84b44e1691275157a6e625f1f3b4478fa04fe052417d8e7ffc42149dec1660bd" => :el_capitan
    sha256 "51f410b68c1b51d91d32a0b1c88ce91459808736377f89a9749080688813d379" => :yosemite
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
