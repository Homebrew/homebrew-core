class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.76.2.tar.gz"
  sha256 "985f330f7502f8e31ad7afbee3742245250e7a0eef91085ef4ae914dce01f392"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    manifest_sha256 "4fd3ddc06273d7477fc281869683eed74a53f284409a70590a38a3357501e689"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "102a3c927323374d4658aff6ce6f3d72477057cc9ed169d33dffcaff02114696"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7e9633b376a15a771388fc1cd2ddc9f38c3a20cb6ca285b937e3d0513cf97dd0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b9e4184509d6fa9e6bdebd3ca300fac0b6d976257871462fb4e6fabaca8b0973"
    sha256 cellar: :any,                 arm64_linux:       "85ef8ca171513f8b5b8dc42cc24e62541fe652241d15e3db63b6572954ab9aa8"
    sha256 cellar: :any,                 x86_64_linux:      "14dc3d4fdd9eb4c614676fda7a27bd4919d68bb06d3db9cd03ef3d8b44585362"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railway #{version}", shell_output("#{bin}/railway --version").strip
  end
end
