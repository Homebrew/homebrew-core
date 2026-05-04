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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d223d9f4b55e6c37da042765aad1a04a59e4dbb63c9e55e955b4700aeebfc70f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a761af3ef32658f71bfef5db8d822f34d1c925c45e77d7d9a0b76620bd9cb604"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd3f9d65b0f9aab006aa2f848a50ba4cd0cd85f9a896c6161e9528739853ce5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6a065ec3ade18e0cf085c6cd8e646a8bd63fd86e4e7646cdfebb411ed487a69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32f9c6fa767f7b928f25267ee6b0462fe42ae89c25e7a7e9e30b2c493bd1bbce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac6d98c1c82ee16334981acc44a50cb91d030809c7250ebe1d35cbd2fd9dd24b"
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
