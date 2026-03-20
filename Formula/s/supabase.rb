class Supabase < Formula
  desc "Open source Firebase alternative"
  homepage "https://supabase.com/docs/reference/cli/about"
  url "https://github.com/supabase/cli/archive/refs/tags/v2.78.1.tar.gz"
  sha256 "a2108843d5af2f9c8dcbe439aff4b355373ebf73ef9b777d5f913a4a80ea62b6"
  license "MIT"
  head "https://github.com/supabase/cli.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe22d08c873566bdba5aa00e209bf8a0776020355d32072b7b246210217d1496"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45794166d9273c99f274b854fdd104b8ac4da39e5a4bca737ff4a02cc4be8c0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1be71cefc2d9867f48005715384375c151beace9b092128341cda89862af0ac8"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa6c115cb8533770d139f86e7ecb71823d8d704c1591237c7b9e9b1d6c9bda37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7c763dd88c3cd0488077c0f39d4cd1b11ce8684bb0645912cfa5d668f11dea8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f139d8321bad65cc0c8f266f3bdd4d6c9c1502c06632582d3bba24be67132c8c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/supabase/cli/internal/utils.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"supabase", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/supabase --version")

    system bin/"supabase", "init", "--yes"
    assert_path_exists testpath/"supabase/config.toml"
    assert_match "failed to inspect container health", shell_output("#{bin}/supabase status 2>&1", 1)
    assert_match "Access token not provided", shell_output("#{bin}/supabase projects list 2>&1", 1)
  end
end
