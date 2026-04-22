class Supabase < Formula
  desc "Open source Firebase alternative"
  homepage "https://supabase.com/docs/reference/cli/about"
  url "https://github.com/supabase/cli/archive/refs/tags/v2.90.0.tar.gz"
  sha256 "74631c8f0ecd88c92e04055bf6fd96862ce47f9e0561dd630565f7c0d1a46d40"
  license "MIT"
  head "https://github.com/supabase/cli.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4fe61df643b7cf7ee8d08495a3b54833bc8e495b8a8b006344b50424696ec312"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dac833b319fffedfd4cdb818622d23fa2ed59374f0937c90c1b2a803d688ef27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "672117b2a0fc2aaba5e9d35e18c38a91ab8395fae7b7309002ad8e5c49afa77a"
    sha256 cellar: :any_skip_relocation, sonoma:        "984ce7ef2dd0b783cd1bafc0b393ba8ae1494ba896abf0ad817bf29c011a5280"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a696c520fb8a9e830ff4659ef1ba4d0469524667136f77a313697b4991b2db6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e0c3a6542d1ddabaeb16e62143fcb9ed5ef14102457289f59373dfacea66b9f"
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
