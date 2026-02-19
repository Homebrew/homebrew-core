class Supabase < Formula
  desc "Open source Firebase alternative"
  homepage "https://supabase.com/docs/reference/cli/about"
  url "https://github.com/supabase/cli/archive/refs/tags/v2.75.0.tar.gz"
  sha256 "90cda59c0851ad3512730936e9b2706b34c00dcc58815d0cff7392ab40e60d1c"
  license "MIT"
  head "https://github.com/supabase/cli.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db5e821104e60b045078c15e9a44d13203c11cd8d3a3c0b131bc75f048f9f201"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56a243b92649ebd7f117ac3a1d8eb393d7feeb2d689cecde1c76352c023ea3a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "268953a6eae0cb3788bc2de0bd721f6329869d13e1a6d9d021b5fa23b67f5f2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "2258e552069e0316a07d0025d1742677f26cfbee3a4166b1dc379cffce949bb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "425632b554d90abcb04264663ff50aaafe37e5aa79192b901cb4eb666a46443c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2db5332d02a31d584ca7c94475b089953535827d7e67d40a42f0938fd90860b7"
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
