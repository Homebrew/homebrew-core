class Supabase < Formula
  desc "Open source Firebase alternative"
  homepage "https://supabase.com/docs/reference/cli/about"
  url "https://github.com/supabase/cli/archive/refs/tags/v2.98.1.tar.gz"
  sha256 "343ce437baffc3f930e3c735956d24d206b4efe3ce929cead9c1e62e8995c788"
  license "MIT"
  head "https://github.com/supabase/cli.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "96000ecbfb9d43e29886f67b5d5b1b8a6aa3b6571d0cc264cec43e8bb95d537a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c820cd0b60fa15a3886a16e6cb8b27a1d6de09a0c8d906af5ea47d9a08d4e909"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5367af140ee49ec89185470a9dd78c0e55a8506ddbe6df3dd279f66a7ebdd6fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e446d289fbf6c2a9c9c43c51a3e646c34f79ada6f59639192194e376f289199"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3284f2cb9ca1297fd0d9e9ee940e61bfa00ef677dcacb83bb53ec3234dce27f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52020a97e67896ec6430eacff1b9e8609221c30cc6aa4ef675b2316db715fa3c"
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
