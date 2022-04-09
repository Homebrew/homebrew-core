class Waypoint < Formula
  desc "Tool to build, deploy, and release any application on any platform"
  homepage "https://www.waypointproject.io/"
  url "https://github.com/hashicorp/waypoint/archive/v0.8.1.tar.gz"
  sha256 "d233a6fd62b76d1e356725cab637c4e61e79326ad4311506e5fbfc54831cc88d"
  license "MPL-2.0"
  head "https://github.com/hashicorp/waypoint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5fc64ecb69cf5206a7b49a3a694ba17355dce90de582d0fefc77a5f5eaaefc81"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "97c43de5b5e15f199b25ce473105c8905a946e73793d2fa7bbbf2a740d3315e8"
    sha256 cellar: :any_skip_relocation, monterey:       "95a1acd530c196592fdeaa804e559cc4b4d4ca2949ad0f3d7522c9eac9cfdf67"
    sha256 cellar: :any_skip_relocation, big_sur:        "061fb004a5d055067dfdf199a7ce6a2c7bbc13c718db285fd0c9a4b51a161fa2"
    sha256 cellar: :any_skip_relocation, catalina:       "e05ed36da7a1b4f8c4045356a99b5ef526a7b898ef38acb342f0e5d0b6bc516b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f920bf5ecb1a4a63fef52336cfefbb51278694831ac27989a326a8f7fa2d2849"
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
