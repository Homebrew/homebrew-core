class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v4.11.1.tar.gz"
  sha256 "b55003cb825db774ff8b7a2201019e08da80ba3f98c841fb82be64d50e0053ce"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76e093ec4c1064d0a309962b5642da617418d230abbf282b2f19fd291a4c8ad9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c08ed1f6a263c089712435aa553f26d17a7b6f502e5d02bd269fef374dec1b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79993d40a2a9588a096479dbe4f0081e62dcd82d849ecceb236457918599ade9"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a4ba72e89d1c12dbfdbb332b4da5a1e7eb2c61f1e54355311f2d966cf7457a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0cf5600d7fa7f912b9e477fd04d7df5751cb08d0fa5523f15a9e26782c0ede94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3952073d0c56d4546113e744196d8ae559b95516dc8fab060a7a90f5f8888ea9"
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
