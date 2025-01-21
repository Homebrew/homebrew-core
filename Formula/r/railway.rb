class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.app/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v3.20.2.tar.gz"
  sha256 "df580f63238a40d5d233acc1654784d227e5027b7b1693f1475db6a001b2957c"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2793cf9e64e8868348bf30b2c483bd1f605ffa26028ec4a9ec0f37404cbbe04a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "890cb022730988c8e0d133e149656c3e8ecf86190ea199c74765b063e254921c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f0f3f1d7d51d763f69521f2500951aa87e65307a3208a07c998c1745ab493ddd"
    sha256 cellar: :any_skip_relocation, sonoma:        "4098361dbc5813214b601c230ae4b9d882a0f085d59f221e45a3344512acd3c9"
    sha256 cellar: :any_skip_relocation, ventura:       "93eb4614d4a660be0b7902af920025cf265cee21ce395c57692b7f3b9ff98d24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba33184eb12898bb4e5b54acf90fbe64e4c5a4a733747e278b8e5d012c241b65"
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
