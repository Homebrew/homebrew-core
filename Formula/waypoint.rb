class Waypoint < Formula
  desc "Tool to build, deploy, and release any application on any platform"
  homepage "https://www.waypointproject.io/"
  url "https://github.com/hashicorp/waypoint/archive/v0.7.2.tar.gz"
  sha256 "da89019fad31ca583c8c8327c8da00fb4a76c278ff1c53583c842bb827496558"
  license "MPL-2.0"
  head "https://github.com/hashicorp/waypoint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4fe997038f23d41652e36df2fc93fb8ac552c4f2aaa9882ece8f52ee870b62cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c2da66f6576474d5ea2b82117e621188a4e3d5ec9bff037508bb7db9a413c2ee"
    sha256 cellar: :any_skip_relocation, monterey:       "3376280748ecb097c43d23c243cb4d271745522c9e7477ce0d0eb40b35ef8036"
    sha256 cellar: :any_skip_relocation, big_sur:        "a55af35b41acd1b81a8b4273722ab5d7092b5b7b764498f35117a54e79ad82d4"
    sha256 cellar: :any_skip_relocation, catalina:       "90f51d815b53d74093df6492fa0a6c9735318136f84256cf2f0fdfd65f5a7a62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "640b0eb1127cc1d5e8e5f1f9a67b124ac6fe6fe62fd6fda277e819436cc9164b"
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
