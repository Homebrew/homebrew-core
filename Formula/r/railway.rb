class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v4.56.0.tar.gz"
  sha256 "ec97d4a16dccd5407407215a6fa4d4f98bd80a9a90ff74e0cd68e8343eba75dd"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9dd658f05fa0c6189c50f9b2d4ad9a8945c54fa8d4606d129178f40ecda298db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "661b233f1a410752169a538d2321a2d7b245ec2100f705c9310ce279dbba13c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68d29df5a7f0cbd78c34a10ac26af0cb1cb7daa6f8e4da7c058c68eba601ccb9"
    sha256 cellar: :any_skip_relocation, sonoma:        "457cd704bc77862c473601fd41dc5af7ace89e9482ed2e8bf79540ab5adc943d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5bc91c36eaa962ba13d88196d1dfad536e6ff466f04b3aaff4d48bb7d35a208"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "659ce6c41110859a17d9516df03f92eec080b24401479f1909804714b10273f3"
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
