class Waypoint < Formula
  desc "Tool to build, deploy, and release any application on any platform"
  homepage "https://www.waypointproject.io/"
  url "https://github.com/hashicorp/waypoint/archive/v0.5.1.tar.gz"
  sha256 "7ae5d969f019c2c5767c2d0251197c33c23058d4cf87329d96a36504c78ded97"
  license "MPL-2.0"
  head "https://github.com/hashicorp/waypoint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5edc6cb128b74b9af818c59bebea28acd9715c4201a97b5be9f4993db62fc3d6"
    sha256 cellar: :any_skip_relocation, big_sur:       "8e0694e9b508aedb9abc96ee45204b271715a7f809553248ce423ab9ad191ca5"
    sha256 cellar: :any_skip_relocation, catalina:      "e3b6f9cd8d70de2af1b9537f9eb2ca87bae9eecb66f6f71ef1ea878c31415936"
    sha256 cellar: :any_skip_relocation, mojave:        "d20a5d1a561bf58ecedad4515f5ca3c11cd52ba6420d8378b10eb76528f1d5ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d5a030f847c342b5b8b5a06531e37b794ebeebac241abc08becadc72c57b486"
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
