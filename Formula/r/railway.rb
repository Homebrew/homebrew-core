class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.42.0.tar.gz"
  sha256 "b6349b5b5b29473b20b32db2e5eca7f15b303abc87b6a0af4d609d9e0c440e13"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de291decf27fcdeb20ec95112ee52da3c6c438b74eae3d23f35f926fc3a1e701"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79f19a17605ca047d0bf2541170300a8708db45d6e04b25c19d578003a7dbdd7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1ad4c95c3ef51a168dc330e69ddd31e64b87b4de9b5242a2e28b2ff790aff68"
    sha256 cellar: :any_skip_relocation, sonoma:        "95ad7e4d00b6466d44887714735bbadfb108f8241e101f7d2bbf1e6de22bbf5f"
    sha256 cellar: :any,                 arm64_linux:   "e02a0918eec9574a0212a2ab33123d9a689e24d60f4fcab8eebe8a6de02dd24d"
    sha256 cellar: :any,                 x86_64_linux:  "e62aaa607da25d84c500632c4a2f319e34ca34df1179c591b383be58b2c15344"
  end

  depends_on "rust" => :build

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
