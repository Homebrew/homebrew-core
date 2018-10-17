class RancherCli < Formula
  desc "The Rancher CLI is a unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/v2.0.5.tar.gz"
  sha256 "c1f9685c71f93f5884de75d0979cebe80042a159e8cfecde1c065caf45ffbd84"

  bottle do
    cellar :any_skip_relocation
    sha256 "be75159a801770dc1ca5f267dd72115733bed6c2c16e2ac6ab7ff78c657d6b08" => :mojave
    sha256 "5b541ab7df1a7454b9f5f0d5a2b3bade5dbfb755d256e1667e4a8ae7f0a28a0b" => :high_sierra
    sha256 "5b7d2fff776705d36182e931358a4e00b8cdb8c597c51856e54ae4092131c1dd" => :sierra
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
