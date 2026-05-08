class Supabase < Formula
  desc "Open source Firebase alternative"
  homepage "https://supabase.com/docs/reference/cli/about"
  url "https://github.com/supabase/cli/archive/refs/tags/v2.98.2.tar.gz"
  sha256 "4b42cabce35e662bffb29dc3b7dd36a3b9c04177fe8ba4800b57c67e05564d5b"
  license "MIT"
  head "https://github.com/supabase/cli.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54cd02ecedd9274ca8922272d16d9d69d6294bcceb00c1f7a3b85ba8ae4f4576"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4dfbf64e70a0fcc0af75e1b70dd8f3d71810e10e78c5757e85ef545c15951b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42afbb69378c052476b1a6f458ab46270c9b3f0429a9e1bd09e97c08e2c8c55a"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d8185631e5ed4024b913b8b154b05e2e195e1fa81f7872f288393dd02b2640d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99429f74c085915e57562e41de410bd8fe29c07f3b1a42b764fe6048556bb6bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "588d2eeb1db8edc4e595290d0a08928548b6cf8e47d771a57f86f831dd6ce633"
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
