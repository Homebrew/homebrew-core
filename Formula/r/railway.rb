class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v4.53.0.tar.gz"
  sha256 "5a665637608d432e357e30ad62201c65131dcc7d97ce175ce8fc35033bc7ce69"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f53d42f9aec7514877198eb93842b92ab329c86faf0d50611b39ac7995def024"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90d69d1fcf54ef5a87a7fb65482b729c3f2de3fb20bb993ec2f37a99e483746c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7568c2b9aaaca3202acfa4c2b6bacb95573d2e336e2169f8b454e71598fa967d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c929ce237699c7fdc0ead55ff7b08c77d3da4b902ebf1ecd90d1b01e6ef92efa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "517fae11f0b0d2335fdd704d668f3b2a495bfc93dab73812173ad4a63ad57006"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fc86c549602ab51c3269f0e62f0eabd4fed5a78b508b7923ba5998f6bc422e5"
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
