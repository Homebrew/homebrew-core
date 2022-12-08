class Waypoint < Formula
  desc "Tool to build, deploy, and release any application on any platform"
  homepage "https://www.waypointproject.io/"
  url "https://github.com/hashicorp/waypoint/archive/v0.10.4.tar.gz"
  sha256 "26f2e4e04596ef2e8eb1a00d52d177ef7d12dd2d5e4fc78261bb3e88fc21d9cc"
  license "MPL-2.0"
  head "https://github.com/hashicorp/waypoint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1028d9ae22e4db4964f1c756c010e21c846f5a023a8524f49c44635c95dfd70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "def6e394e20473e96ba6e7ff029433d7ca69b458685822f01e7457f8ed8f8288"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b893887efe3f7a80fad05ba5e7bf0ea53ac41d6da81d8fb6f5fb4e0d5a3d1ee"
    sha256 cellar: :any_skip_relocation, ventura:        "d0be1630b949197cb3b31a4896c80bcf5f424e91c8f14832007dd1369cedff0a"
    sha256 cellar: :any_skip_relocation, monterey:       "84fdd449bcea32ccde19d01f8fa7701156aaef0b80c83b1649c7452b7c1879dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3ceef96469185bb46d3c4598d8ccb43170ad0e19966813fdb5e2c748c2d65b4"
    sha256 cellar: :any_skip_relocation, catalina:       "83357984387712f73160c9b0a468930ab69d94cb26e59ed0efb0df4d4992eeda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d20c3ea0427f1893ec97a4dccd1419350b638f70820881610dca43fb9b3e489"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    system "make", "bin"
    bin.install "waypoint"
  end

  test do
    output = shell_output("#{bin}/waypoint context list")
    assert_match "No contexts. Create one with `waypoint context create`.", output

    assert_match "! failed to create client: no server connection configuration found",
      shell_output("#{bin}/waypoint server bootstrap 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/waypoint version")
  end
end
