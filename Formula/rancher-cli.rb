class RancherCli < Formula
  desc "The Rancher CLI is a unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/v2.4.3.tar.gz"
  sha256 "9e35b653f472aead86fbbd37bde6f3f311fa4f808d4230f091e18fcd4f7fd9ba"

  bottle do
    cellar :any_skip_relocation
    sha256 "e13728983d02cee14fdd22331f38955ea4cf9e582ba00eb30a0613a28fc2369e" => :catalina
    sha256 "20c896b75c51e9ae8984eee6b75a4657c8c76205e28180c4e4b87960e8527bf4" => :mojave
    sha256 "f666f5589a275067fe0eacf4728b84c8f182816a2caabf4cf4442a74c9f2551d" => :high_sierra
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
