class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.app/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v3.0.18.tar.gz"
  sha256 "0d5477f722e58246c29b7ab8c35d11427bebc986341e0b39d01d9bbba7ecda57"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5dfb38dc297e5adb0a798c814baaac55f2d51d7711061fb807c7acadb24d3f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "062320cee914af763d0b07ff952a839ab48b4d9bc81f2b9e887d5af0e2226561"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68b4f248bbccbf8672ac6bedf86d4bfa4ec7802e4a06d314219d5f16e7a5e6c9"
    sha256 cellar: :any_skip_relocation, ventura:        "955801943e6053e683a9951d629be80d8052b397b3ce1ff55c814b6659e60193"
    sha256 cellar: :any_skip_relocation, monterey:       "57375f1d567d780f21121ca300fa089f16340f03f9fc001d5a42baf4973b97b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa2dfdff6962ca1de1068e2ce62273a8cf8113a262bdd4b09a069cd2f588f544"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4198d95592abbdabcdd0b86dde73f47b73cbdcaeccca7a0fada44a1a946bd1c3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    # Install shell completions
    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1)
    assert_match "Error: Unauthorized. Please login with `railway login`", output

    assert_equal "railwayapp #{version}", shell_output("#{bin}/railway --version").chomp
  end
end
