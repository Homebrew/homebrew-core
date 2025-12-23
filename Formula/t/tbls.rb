class Tbls < Formula
  desc "CI-Friendly tool to document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://github.com/k1LoW/tbls/archive/refs/tags/v1.92.2.tar.gz"
  sha256 "068f4eb86146c917f29372dbdcda42f6a59a56a70841f3aa48021cf49975accd"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df1f4d6c069c4b6583363adc9628d878b2ef3a87c9f9a17237574978ebc9ee90"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95b010f2c90bb8b61de1eb6a804111522a46d7e04541f942c59fc9a6a84bcccd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f12b7ecbef7bc3505587998a76a281f1ea189284c866976210e6912d3083582"
    sha256 cellar: :any_skip_relocation, sonoma:        "47aea81fbf2a041de54b98459021f7ede91c40652f1d807ef93f834dc7981c70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5dbb4c6e74846928db706a88feab33735f194194abcf3ccc571510ee8993079"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fcde201c8043b9578fc7ba34945b9e5118c5c226bba2fc89c4059b9beaecf15"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/k1LoW/tbls.version=#{version}
      -X github.com/k1LoW/tbls.date=#{time.iso8601}
      -X github.com/k1LoW/tbls/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"tbls", "completion")
  end

  test do
    assert_match "unsupported driver", shell_output("#{bin}/tbls doc", 1)
    assert_match version.to_s, shell_output("#{bin}/tbls version")
  end
end
