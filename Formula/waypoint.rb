class Waypoint < Formula
  desc "Tool to build, deploy, and release any application on any platform"
  homepage "https://www.waypointproject.io/"
  url "https://github.com/hashicorp/waypoint/archive/v0.7.1.tar.gz"
  sha256 "cf62a3ee7e75dd0b923072e6ce61a5920e568b6b6b550ba3184b3ceecb220e1a"
  license "MPL-2.0"
  head "https://github.com/hashicorp/waypoint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05cb79b1339050d7ef2779cdde61b2236dd1161c2cee03a15f9d65bea750bfc3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "481fa811ce113775604a4a4e21f35818d851f396aa7e3b42bb2f2f1950901ac6"
    sha256 cellar: :any_skip_relocation, monterey:       "762f7c09181808f0605f7d04ef791abdd563a9faa5fb0f8a055f2f7f7ac4b9f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "39d77c3fd3c3ce70e46e0aadd2819f710662b7d7484e5bd61bc4b311d4d58a22"
    sha256 cellar: :any_skip_relocation, catalina:       "2c8e1b222c6ab9975e1fa5b8c70e8feb8a302a6d17386d7f49574460fd11967e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbed671774917fe5f4d7c025e3028e62eefae266be2b0008cfaecd9f840f2291"
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
