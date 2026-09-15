class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.57.2.tar.gz"
  sha256 "cfdd43f669e99ab551791316f150911ff94c0d07ce96370828fcd15bfde8839a"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4058ad78a3fa7fdef8f71ca2de23c4c6d599d4d81b35f62935ae1a9cc1acd9bf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "449116464b088d23f38a7f54a79b1fbae26d982c3a5ab25095644a92afa84d89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "18006fc945f77037930839e8b0e6b0fcd99229c5135648eaf0644f7db7fca298"
    sha256 cellar: :any,                 arm64_linux:       "d73454cb3ae6a88e219fd6742cb72fbcd7cf563528fe8f5f1e67894f646898b3"
    sha256 cellar: :any,                 x86_64_linux:      "6f513e5561d0681fbb08281c168d9ce7f806269394d220f4d2757ee777df2d79"
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
