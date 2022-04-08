class Waypoint < Formula
  desc "Tool to build, deploy, and release any application on any platform"
  homepage "https://www.waypointproject.io/"
  url "https://github.com/hashicorp/waypoint/archive/v0.8.0.tar.gz"
  sha256 "8a068481a5985285ed25e96ad6983c0aedf4a2c27934f19095bcb8d2641d571c"
  license "MPL-2.0"
  head "https://github.com/hashicorp/waypoint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8eb96c9daee9ad1d54a0e1657c8a0792b9d0aa1162881aedf0717f74649b855"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45183a6556c614f01445406bd77dbad96a87be4e68bbfca9857698fc406643d7"
    sha256 cellar: :any_skip_relocation, monterey:       "da1b2fccfe09e2fb5095d3a10e88e5e067428648bf307e7897b4b7435eb6cbd8"
    sha256 cellar: :any_skip_relocation, big_sur:        "92b377654e17904405b22cb61945a8b538526dd2bc1c5ab947b2c59c64d1eac9"
    sha256 cellar: :any_skip_relocation, catalina:       "ec9249b78fefd43b34aaa2989b8ba3afd3e0d39c0e2a140c86a8904ad33e0b70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6dce201c9e24573bb00293819dfd377861b8d020563ce6aac8881ff7df8142e2"
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
