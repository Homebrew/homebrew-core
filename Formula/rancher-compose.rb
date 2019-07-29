class RancherCompose < Formula
  desc "Docker Compose compatible client to deploy to Rancher"
  homepage "https://github.com/rancher/rancher-compose"
  url "https://github.com/rancher/rancher-compose/archive/v0.12.5.tar.gz"
  sha256 "cdff53b2c3401b990ad33e229c7ef429504419e49e18a814101e2fa3c84859ea"

  bottle do
    cellar :any_skip_relocation
    sha256 "bf318932b401481ee6e3a94c82c617b21e558406ebef9739c1c7bb42441e9eda" => :mojave
    sha256 "63f6da5eb59cb86c8f84975b3d3ee41f0bfc1456b239d1a6cc06a648d57e1967" => :high_sierra
    sha256 "08f3fad4e6c1df545dd908b61afe47ed489e682ad2cadab384066237498a2a04" => :sierra
    sha256 "8503ea7d7ca208ca7fe8d0c0b81f9ab9b69d926c58f856ac9de4f9f3600cde17" => :el_capitan
    sha256 "23291133a0a775210ae1244ae594931ce04fab8e7c0a37ba90431d61d869317b" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/rancher/rancher-compose").install Dir["*"]
    system "go", "build", "-ldflags",
           "-w -X github.com/rancher/rancher-compose/version.VERSION=#{version}",
           "-o", "#{bin}/rancher-compose",
           "-v", "github.com/rancher/rancher-compose"
    prefix.install_metafiles "src/github.com/rancher/rancher-compose"
  end

  test do
    system bin/"rancher-compose", "help"
  end
end
