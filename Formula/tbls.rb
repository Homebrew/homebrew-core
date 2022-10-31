class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://github.com/k1LoW/tbls/archive/refs/tags/v1.56.6.tar.gz"
  sha256 "3416b656a0f40646bd48cb519e88c9e2e645690645dd5791aa4a07e125a60c64"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e7d5a8082b2cc495dc45aaabfcdefe6e25b8a178c350205a1bd705d30fcf9e0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2565bf22b5a0862e0ef86bbba30ce27c09b237c40d2498894f7417ce65cbedd9"
    sha256 cellar: :any_skip_relocation, monterey:       "7f141cd2ca8399d766587ecc39989344fbcc0d088e0c591114b12bb57a7a051c"
    sha256 cellar: :any_skip_relocation, big_sur:        "1c1cd1329c5ba135ecad50214be91eef061706c9823a87422b9b94791f855dc9"
    sha256 cellar: :any_skip_relocation, catalina:       "4cc38c07075e22651a8c58b820c4006321acd1cbf3f2ec32f47301e11ddc54ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc96b032745eb135a9dd309b2b50b68879e4381496aac4d314e5c13eb25e693c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/k1LoW/tbls.version=#{version}
      -X github.com/k1LoW/tbls.date=#{time.rfc3339}
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
