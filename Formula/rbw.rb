class Rbw < Formula
  desc "Unoffical Bitwarden CLI client"
  homepage "https://github.com/doy/rbw"
  url "https://github.com/doy/rbw/archive/refs/tags/1.7.1.tar.gz"
  sha256 "8c8dc95dc0846c0c51f0b13c9e60a4b4e722c8befb932e8d06c462d70deaf096"
  license "MIT"
  head "https://github.com/doy/rbw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "640a874bbf8ee81a2eff163e7397e84aa906591401aec78aa091b744c0c1bde2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5253565e425c8aef332b878a5463a75cd7ebc3ef453881feec0c2bbfb6659fae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc03304390d20818c01270bef91d770c3590d5a10c1d39f4ca0af9d2ae8ecf92"
    sha256 cellar: :any_skip_relocation, ventura:        "04a385e10c466bd9d21f08cc132fa172c1ab4e0c54ec99c6c91fdf0dbec0fcc4"
    sha256 cellar: :any_skip_relocation, monterey:       "fca87815c1ba256da6ead90ff719a65d693a84c4258019b7a9329205d8ce0179"
    sha256 cellar: :any_skip_relocation, big_sur:        "1df8889e9ad7b834ed8426b2105fee4ea4a6d965ed576ab0f901f3f4c01898f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df9513b677aa8654f2235e4993c9e0fbe95dae5b45f25aaf1b496ab7beb5e393"
  end

  depends_on "rust" => :build
  depends_on "pinentry"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"rbw", "gen-completions")
  end

  test do
    expected = "ERROR: Before using rbw"
    output = shell_output("#{bin}/rbw ls 2>&1 > /dev/null", 1).each_line.first.strip
    assert_match expected, output
  end
end
