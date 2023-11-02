class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://github.com/k1LoW/tbls/archive/refs/tags/v1.71.0.tar.gz"
  sha256 "e32e4109025ae2370938a7bbc1d70727f203c19660fc638a8dd7d56f4218a4b4"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7d68f8b258081907295462b865e61c766775e01e5b9ea5efca50245233d015fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac1fc9b907f81d7e4046f9b6967b68d9b701ebad151e9c00a8b17e836c30e89b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5061c32e2c33b389b500f771335ee1cacc5528031fddf535db6c1c12c25afe15"
    sha256 cellar: :any_skip_relocation, sonoma:         "e97113baa5bf7648a66c06c186d7bebeffb4f39fd52649ff390a780e820fe6a8"
    sha256 cellar: :any_skip_relocation, ventura:        "7194c3e00950c81dc007b5a48b6ec3be2b78c2cec7008e111057005d5e4db29a"
    sha256 cellar: :any_skip_relocation, monterey:       "ebdac93d762df536a888e1d2b77b0acb26f9f2217f4da1f7be940f4ea21a675b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dff46c12c99b7b1c7be15779c4a2405217e47eb5d969800eeb551fe44a7dc707"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/k1LoW/tbls.version=#{version}
      -X github.com/k1LoW/tbls.date=#{time.iso8601}
      -X github.com/k1LoW/tbls/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"tbls", "completion")
  end

  test do
    assert_match "invalid database scheme", shell_output(bin/"tbls doc", 1)
    assert_match version.to_s, shell_output(bin/"tbls version")
  end
end
