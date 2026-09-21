class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.58.0.tar.gz"
  sha256 "27eb284ae49446f32ac8f383fa9eef39baf264188278ac55dd9bbd46406259c3"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9a75bc3991107de99c0ef2aae5ebe250a8dc88370f6eaa9a705d20e5519c1256"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "959d3a050f418dfbbf418d56b4de5cf2f63ae3205658e4b2c225270489ffd1e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e3f8ec498e03bed9c6b1e0a3abe9ad4c0d6940ee9a52d178a78653bf3ab93064"
    sha256 cellar: :any,                 arm64_linux:       "40db986f2748eb9a4bdd427fd2efa17a1e104e0f47fed6278eef70d8acf27967"
    sha256 cellar: :any,                 x86_64_linux:      "4b1711228c9d1c76cb5d4274bc14a5dba10b314bdfd774c3e8b694ec51ad69a1"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
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
