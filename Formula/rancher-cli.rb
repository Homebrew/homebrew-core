class RancherCli < Formula
  desc "The Rancher CLI is a unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/v0.5.2.tar.gz"
  sha256 "4b7bd71f9f23e465e61c1cd5fd97957fff3265fad6e90ca51c48322bede9108b"

  bottle do
    cellar :any_skip_relocation
    sha256 "d68c252c1edeccec09b639027ada429380eff32a4336695d40b8142af8f1b4de" => :sierra
    sha256 "f84124cb0d665718e39293b02821e337944fd520c51f4318deebb90450fa40e9" => :el_capitan
    sha256 "653f97ddd4d0692b671d1e0df8eca389106871ba46c76c9d74581aad7616ff93" => :yosemite
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
