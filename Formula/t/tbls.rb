class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://github.com/k1LoW/tbls/archive/refs/tags/v1.76.0.tar.gz"
  sha256 "ceb4129fe661079495e096ba0e2f324eaabfb598300c9c4fbfe594fc931d99d1"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "95e4d5b030101a5e4df774aecb056c18c87f55fc970b2df546c67b63ea684d21"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c157781ce6eae0bdcd0d8141bc6aaf6a5a2114f93dbaf51efd308bd8faa59194"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f98271d7a4ebd5f2cd3157bdafd2a4df5ba7b9708c267c896dc3405e4d18b40f"
    sha256 cellar: :any_skip_relocation, sonoma:         "edd48071022d200d2d590733e93f6dd785413fb74ec222bc3b9dd52132e49370"
    sha256 cellar: :any_skip_relocation, ventura:        "dd6bfb23c3fc6316a90a4bdc4dabbd64584bf7f2c9e2ee9e93faf37c9bd12271"
    sha256 cellar: :any_skip_relocation, monterey:       "2081f9b162946a9fbbb426206750f2003cbcd7d39085c5cff315a910059b34b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dda3d0b639bc5bbcdafed8d804a0bdfb777c8c65fddb0352139783cd825b9320"
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
    assert_match "invalid database scheme", shell_output(bin/"tbls doc", 1)
    assert_match version.to_s, shell_output(bin/"tbls version")
  end
end
