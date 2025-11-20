class Supabase < Formula
  desc "Open source Firebase alternative"
  homepage "https://supabase.com/docs/reference/cli/about"
  url "https://github.com/supabase/cli/archive/refs/tags/v2.58.5.tar.gz"
  sha256 "e0409d3567db0d58333f9327b2664da612d04bc80ea2908f3df66e8a1d36f39f"
  license "MIT"
  head "https://github.com/supabase/cli.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee06dcbb069cf7b985303ecc08d7f75405f847a40b4729450e14a1045b249f13"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "820d5c94cc5dc0806f67ce54e4718b2560dee07952671b741300ddedd1e3aa28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a561960b5f580ea3e39b477d7782d7be8461314ca51af2c8e19dacf7903116d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b01f8e3bb0b3695a20d3646782200376595529c0c870cac4b57a12493585720e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b50b99b1f1e239d66bd066c5f6c2b9f8f63f626c68964ef907c7dbd082e00d60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7becfc1c81d0180a0b1941602e6e1d5c54bd58350ea92ac898b0a05d719abf2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/supabase/cli/internal/utils.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"supabase", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/supabase --version")

    system bin/"supabase", "init", "--yes"
    assert_path_exists testpath/"supabase/config.toml"
    assert_match "failed to inspect container health", shell_output("#{bin}/supabase status 2>&1", 1)
    assert_match "Access token not provided", shell_output("#{bin}/supabase projects list 2>&1", 1)
  end
end
