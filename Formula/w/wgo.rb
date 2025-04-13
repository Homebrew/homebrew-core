class Wgo < Formula
  desc "Watch arbitrary files and respond with arbitrary commands"
  homepage "https://github.com/bokwoon95/wgo"
  url "https://github.com/bokwoon95/wgo/archive/refs/tags/v0.5.11.tar.gz"
  sha256 "43da88bf03296dc8c47d7309dc15d2121fac303e4d78a0db5882363748d4ad12"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a078b99cb9070cef3a7ea6cb635fb0df507265703baf8796876862265d1e1143"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a078b99cb9070cef3a7ea6cb635fb0df507265703baf8796876862265d1e1143"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a078b99cb9070cef3a7ea6cb635fb0df507265703baf8796876862265d1e1143"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f955a8850bb8e4f19f8acf3712dcb2c70a082854a9f10c0f229a351b630de16"
    sha256 cellar: :any_skip_relocation, ventura:       "6f955a8850bb8e4f19f8acf3712dcb2c70a082854a9f10c0f229a351b630de16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be7b9766825d6a3f188eb24e23e076861a3131ccf80cb8653c3d4507a7200956"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "952cccc76bb62762cfda6e256a1baff764172cf33c61b200647ef18a70282049"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/wgo -exit echo testing")
    assert_match "testing", output
  end
end
