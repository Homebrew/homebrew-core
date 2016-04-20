class RancherCompose < Formula
  desc "Docker Compose compatible client to deploy to Rancher"
  homepage "https://github.com/rancher/rancher-compose"
  url "https://github.com/rancher/rancher-compose/archive/v0.7.4.tar.gz"
  sha256 "a0d285dd0608323c28a78782e85fbe3f52ddaad9d101030fad39efe3b20dadc9"

  bottle do
    cellar :any_skip_relocation
    sha256 "5f56b8daedd05565f18e0c3fc66ffa84ad225db4ca395ee98bff7b111852068f" => :el_capitan
    sha256 "07e184c92d60e0cb081a81b478d080717f73bf456bbd01a037fed5b701a71d2c" => :yosemite
    sha256 "7d48e31e6d881d4fc6663e0ad229efcd876b1a9f6d28939827b2feab5dc5bbe9" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = "#{buildpath}:#{buildpath}/Godeps/_workspace"
    mkdir_p "#{buildpath}/src/github.com/rancher"
    ln_s buildpath, "#{buildpath}/src/github.com/rancher/rancher-compose"
    system "go", "build", "-ldflags", "-w -X github.com/rancher/rancher-compose/version.VERSION #{version}", "-o", "#{bin}/rancher-compose"
  end

  test do
    system "#{bin}/rancher-compose", "help"
  end
end
