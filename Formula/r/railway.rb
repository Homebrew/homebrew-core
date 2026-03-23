class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v4.33.0.tar.gz"
  sha256 "6e67c450ba34a0c998d51167e4c1766630a4f0b0d30a41d4afe474076b4522be"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15976f55181e8554245b68e1e0191da16e18a24aebd2f1c8564084432a83159c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1168fefa70a905a302ea97c9e676ff51f51ecf191c25e9fd8c7b9d24251b76cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70a2f9c04c09ee358f10c3cdeefa3e6705092e1d61523d3be6b7f79b6f6f85c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "898520742c05433aaca290574fe913482a2bdaab8b1a45b70e51c28c7288d2db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ef31be050e6bacd2b095f45565fa995cf259c8534b0c95af36704072e1b2b68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10f4a511b6f6e5dfb5519f29b5dbe8381e9e3fe5e273e829f5060aa6ddf50531"
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
