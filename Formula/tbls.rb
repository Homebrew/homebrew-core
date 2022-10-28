class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://github.com/k1LoW/tbls/archive/refs/tags/v1.56.5.tar.gz"
  sha256 "fb61febba445cef8e025e897e53ca5af4ef15c2c087da5299d2b94860e06f231"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e12d25183396bbc2b2de2b9edc74f9534d8a7cae7f93ed7523a0c227144c7274"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b8caaee535739dff9d8c61412772859f482dffb22199c0cecc4a4f5e876b7463"
    sha256 cellar: :any_skip_relocation, monterey:       "d283631f8e5582d54c8eedb5b175b01e7699d458f60a73e97c77b14f08a15dd2"
    sha256 cellar: :any_skip_relocation, big_sur:        "d1812144cb010d24afb50bb11bbc0603b409a1da47492de1336b10b047eb833b"
    sha256 cellar: :any_skip_relocation, catalina:       "b9c1bea95a6b8c5f8106fb84952b77fa9be4d05e8fa793795da358f6a3846f9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dee372873e09511aa898d049c1366e9b8eddb68b8157fdb51f8c9be8e67dadde"
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
