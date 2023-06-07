class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.app/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v3.3.1.tar.gz"
  sha256 "68083661599e2f4b7fada400071b9f311fc56c7d4625407f7ca011bfa285694f"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7427b29752120ffb2901741c1a1379a3fd067a3709bb79f538ee2ea849553e57"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed3a54463f8a0114485e89f90e744173936731a5abfdac0df9924257aa913dc0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bdc19c54b34c80914856c1290b0e821a2564e7099142722976351c62c7340409"
    sha256 cellar: :any_skip_relocation, ventura:        "7e070b048e960504774edfd4c8b0760eeeeea97f2e33b9e362b8c6b584036ff7"
    sha256 cellar: :any_skip_relocation, monterey:       "431db27f524678173195cf5b478ebc5b28ce3c0791dbc29b5d59447b6c6e0590"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a95eaa043508972e0c1a94a1ee8a4729793a1396c8ba6bb56b81b6c9e2692ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0236cd87057e09d949768afbfaadec40dbc5c53357c3d1b22bb44c8e0eb321eb"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    # Install shell completions
    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railwayapp #{version}", shell_output("#{bin}/railway --version").chomp
  end
end
