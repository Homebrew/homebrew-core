class Rospo < Formula
  desc "Simple, reliable, persistent ssh tunnels with embedded ssh server"
  homepage "https://github.com/ferama/rospo"
  url "https://github.com/ferama/rospo/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "338157a7a34abf35f7fdb84a1667c49e07d95cd3ef33e8e5f9ce2cb0e55d4647"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "098ce38c1855fffde3d35d6ac17f8f83ae154014725a8a6e88200c5eb19c7135"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "098ce38c1855fffde3d35d6ac17f8f83ae154014725a8a6e88200c5eb19c7135"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "098ce38c1855fffde3d35d6ac17f8f83ae154014725a8a6e88200c5eb19c7135"
    sha256 cellar: :any_skip_relocation, sonoma:        "04c2a346275bf6ad2b999c55f3e47531dbaa5c63be2db2e30ea43210f72ab6da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a09ced40fcb5678474430ece4175e646fa6ef02e87d87d32b8fe6650a388dba0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6448928c03fe0e27d84213e2ac02508ffdf652df73c6eefcc008df82c641c5a0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X 'github.com/ferama/rospo/cmd.Version=#{version}'")

    generate_completions_from_executable(bin/"rospo", "completion")
  end

  test do
    system bin/"rospo", "-v"
    system bin/"rospo", "keygen", "-s"
    assert_path_exists testpath/"identity"
    assert_path_exists testpath/"identity.pub"
  end
end
