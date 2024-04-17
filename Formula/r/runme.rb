class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/stateful/runme/archive/refs/tags/v3.2.5.tar.gz"
  sha256 "bcf22647b4c748b014d17d47a7edb88c89bf21c2766ccadbb686f3528df0d0dd"
  license "Apache-2.0"
  head "https://github.com/stateful/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "73c6d81c3eba3d6306203d7b8eb02bbbc4fe90fc135a905a47b9f29aa1df82a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95573bc98e90f05b18ce5b4f8a946eb69bc97c4bbbd4a888e2d950f894db893a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0a945c08b4ecda2c1274ae688aaca3630623893c0484a456484aa35712582c7"
    sha256 cellar: :any_skip_relocation, sonoma:         "8cd7a5ab82b4c4588e5aa7a45d5ff32e243915f84d323e38d5de6265a2612206"
    sha256 cellar: :any_skip_relocation, ventura:        "e05a04b752af6eb8112147169c5f08c0c13186e64a03aab3bcba8f46cacc457d"
    sha256 cellar: :any_skip_relocation, monterey:       "a1c2f43244704353427f8d6bd51bf725fc0bacc789d203ede4b471705192b1ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "289ea5ebfbbd9263a4345e133c3c6d30f65d02ca6e3352debb9d440584559cff"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/stateful/runme/v3/internal/version.BuildDate=#{time.iso8601}
      -X github.com/stateful/runme/v3/internal/version.BuildVersion=#{version}
      -X github.com/stateful/runme/v3/internal/version.Commit=#{tap.user}
    ]

    system "go", "build", "-o", bin, *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"runme", "completion")
  end

  test do
    system "#{bin}/runme", "--version"
    markdown = (testpath/"README.md")
    markdown.write <<~EOS
      # Some Markdown

      Has some text.

      ```sh { name=foobar }
      echo "Hello World"
      ```
    EOS
    assert_match "Hello World", shell_output("#{bin}/runme run foobar")
    assert_match "foobar", shell_output("#{bin}/runme list")
  end
end
