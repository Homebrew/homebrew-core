class Rospo < Formula
  desc "Simple, reliable, persistent ssh tunnels with embedded ssh server"
  homepage "https://github.com/ferama/rospo"
  url "https://github.com/ferama/rospo/archive/refs/tags/v0.11.5.tar.gz"
  sha256 "57550763290cbb9d56c56af1777f0f9de9afefec46a812c7e1feda8b85288b5b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f444102767f76f2cf6e8cf44f35e88fcd041218345f481b5d659dea7d1f1f990"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8575acd0b5a87713c1a6bc826cc2a2c17e440d7e2747a4ff25ce453aceccdadc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e781f53bfdd34f65e24d7d60bd0b01f88ca581e877f600314c523a00ce8d37c1"
    sha256 cellar: :any_skip_relocation, sonoma:         "4df0daa2ac4755f711667bd5ead4cb0b4f3162062e9d2135fdb92329ddc2b495"
    sha256 cellar: :any_skip_relocation, ventura:        "865fde0b73f5c68aff75f9f83d3e6c6583ef5c2062060da9bc36503f65f9e306"
    sha256 cellar: :any_skip_relocation, monterey:       "3280750d4f1e049ec3b8cf1741174288a09ac8c50ea3d15b9078ce6061e5b794"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e583108b9eef69d4e2db013e7a09ba809da58dabef36cd94fc0b5f3975be75a9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X 'github.com/ferama/rospo/cmd.Version=#{version}'")

    generate_completions_from_executable(bin/"rospo", "completion")
  end

  test do
    system bin/"rospo", "-v"
    system bin/"rospo", "keygen", "-s"
    assert_predicate testpath/"identity", :exist?
    assert_predicate testpath/"identity.pub", :exist?
  end
end
