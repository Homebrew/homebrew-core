class Waypoint < Formula
  desc "Tool to build, deploy, and release any application on any platform"
  homepage "https://www.waypointproject.io/"
  url "https://github.com/hashicorp/waypoint/archive/v0.5.0.tar.gz"
  sha256 "66cb6cd23bd809ac19ee94a01fd6d1e82101b698b44e3be7a6839a8cb720ca30"
  license "MPL-2.0"
  head "https://github.com/hashicorp/waypoint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ac4a7795630e4bd6b14236e899ae8539f8ea566126a532b9e14144b368aa871a"
    sha256 cellar: :any_skip_relocation, big_sur:       "f9a42c0c4d81b363ac7bb236cdb5eeb13329df982c1b46d4c07a2f05ec2ceddc"
    sha256 cellar: :any_skip_relocation, catalina:      "79b4ff7c89577db65ad49f4a33056f82db0f1be27dc81269ed6a56b445d0cd9a"
    sha256 cellar: :any_skip_relocation, mojave:        "5f7aeb505ced51b7b532185afcecdebf07e52a107845b80bd8b574bc6c87a4cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76a88b7a546d41dc24d43b2f18223782afb2a9f8c25ad4e1723bd6fae2839f9c"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    system "make", "bin"
    bin.install "waypoint"
  end

  test do
    assert_match "Initial Waypoint configuration created!", shell_output("#{bin}/waypoint init")
    assert_match "# An application to deploy.", File.read("waypoint.hcl")

    assert_match "! failed to create client: no server connection configuration found",
      shell_output("#{bin}/waypoint server bootstrap 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/waypoint version")
  end
end
