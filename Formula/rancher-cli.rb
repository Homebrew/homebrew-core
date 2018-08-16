class RancherCli < Formula
  desc "The Rancher CLI is a unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/v2.0.4.tar.gz"
  sha256 "a902d54717bb9c4152a7400b78b9455bfa6ebb5ec51906c63f26b91b5b51d29c"

  bottle do
    cellar :any_skip_relocation
    sha256 "637bc7f664fd8c9b84bfddb31e47cc074049434160aa7fdd8db89b1f0e10983f" => :high_sierra
    sha256 "29b6bb40da3c8e72e1fb0a6ef734e13817b02f0a697749902dd48efddf80ae10" => :sierra
    sha256 "4587f6c4e7b452db3d6545e637222e2f572f69668fb29db9fdfa14dc53de370a" => :el_capitan
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
