class Supabase < Formula
  desc "Open source Firebase alternative"
  homepage "https://supabase.com/docs/reference/cli/about"
  url "https://github.com/supabase/cli/archive/refs/tags/v2.72.7.tar.gz"
  sha256 "8b32027af98bc253c06b99b7d549622cee62c941228d9807a770f14cccfde6e9"
  license "MIT"
  head "https://github.com/supabase/cli.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "629d76dd7ed60100da0f768cab9219893c1e8e88eb4d8eb9b36439b3ed975a18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ff694034ece4f4f13fb923f45fbb4cca094e394241fe692cae124cc43bd75c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ccb65de36130a51ae0a11eb6c388f20d9f80a102bd344e2e1c50e1e580ed7b75"
    sha256 cellar: :any_skip_relocation, sonoma:        "148b27378e24f1fa9e956425245d0ecead6c3e0c0dd3e8f866f4deef2eb6357b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b5f2ae6040c386c0ee9869de69a37b1642af0af60900c7194148a2896e377a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73ea13b5047f639561bf57580500437703c7fe49e9943359bad48e10cf7b43ac"
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
