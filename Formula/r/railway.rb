class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.app/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v3.21.0.tar.gz"
  sha256 "2035767de31f2b756043ac7521b7dc35a082436bad725f68e22106c7a01a591c"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "421d275d605c30e21e14f025a886019cbb782845422ac91a29d109f4c25549d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "160f203809efe155dc0344646c9604d23a6aebf29c0b18d94ec34c3bc925ba5e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cbea2c6765089dfecc1f884a7d8f3eba5f1ff7737e5b0831fd9f8e2af2eb3c0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "bef4a3f6352f5acc498326a463f868169f76f10699e3f1d3818f6db6f4790aee"
    sha256 cellar: :any_skip_relocation, ventura:       "73f81745386260165e3dcb9f2923e6bcfb819220738a3cf6ba10c79ab9379981"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "887861483b62bc842c7edc58042b81de11a2c311bdb1da83dad09ea8fe32b1e7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railwayapp #{version}", shell_output("#{bin}/railway --version").chomp
  end
end
