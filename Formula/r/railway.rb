class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v4.12.0.tar.gz"
  sha256 "7e9c443df9e02d4095501d8d6d4c43a8f32f5c9239350c5d833c7be00a69743a"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a50e23a899f8c69831fcb827844f005caa6feeeadc7914893174f75ef74192c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d404b845fbe488bfdc07f129a52936f0ac2290a83f5cf8b2e9b3906070f127c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7cdc4c10f397e28b908d1c92e762031eb30d85e6b76fb289d0627a9a65fe37d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "a10980207e04e222f2dfa9276b0caf9750bbea4df3b16fb8131baa8ce0c2b61f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26eebdd711b76caa1bdea32ed11495718f7fd454c559241b244a5e48c4bffea1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "deb40b8907e6ca138363af23a2f8eff428fa0a1ecafadaed208f1e3ac80911e1"
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
