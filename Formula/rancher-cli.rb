class RancherCli < Formula
  desc "The Rancher CLI is a unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/v0.6.7.tar.gz"
  sha256 "1143f1b6819345ad1b3dfa92df1853e6aaa4c8e3abeb719bada476e51473b494"

  bottle do
    cellar :any_skip_relocation
    sha256 "270900a8d64f9232b15e551de7c9ca912eebbe0bbcf175a8c934b710e5cedcc8" => :high_sierra
    sha256 "650f41298ec0c97700e121ca1e264e50623287b680311a84d183cef673016573" => :sierra
    sha256 "5c83744b3f8a918805e20213853996fd249a9caf7b1e89cda8477a7cd785dd9f" => :el_capitan
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
