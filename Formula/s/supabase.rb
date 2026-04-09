class Supabase < Formula
  desc "Open source Firebase alternative"
  homepage "https://supabase.com/docs/reference/cli/about"
  url "https://github.com/supabase/cli/archive/refs/tags/v2.84.2.tar.gz"
  sha256 "4eefac9d0abd093fa35035013da4abddc0914c1c74c1a3ea46bdd4ac108b12f3"
  license "MIT"
  head "https://github.com/supabase/cli.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ca3446743bee31cb301de220c1b35a775abfecbd83616f38e0d1fe88a088d65"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58edac71eef196ce038a89c98631563fc55eea4bec9adc0dbb12237d1efd18e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63f09dd4a93372cc9600b83a530e391b0af96b2b462a62cfa8e627bf0c2d3a30"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ad32dac373ef53c4f9d4f80b820ef73a7c6f5a135fb9919f33cd773dd119bcf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ca906566cbd25d97ec80e3b95c67423c1d849540a4fc8da381a15df20343e0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f5b84dd38613667fa5505ec7ca9d7f4bc49ae475df7f3536ad6919415ab65d0"
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
