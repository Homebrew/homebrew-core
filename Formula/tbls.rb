class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://github.com/k1LoW/tbls/archive/refs/tags/v1.57.1.tar.gz"
  sha256 "126c94a9611f06391e22c961e4ad91cfd64074915482b40c8db53a98b072114d"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a85075662858d46dcf10e3acb3bc4bb9e1023b0f59cd812ab70526a6bb503e3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a2399f08d2d2d72bc5924b70f67f1dc88cbf13fef59589599c972b598822844"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b30d51ab34c89755526a7a0365c2344bf63539814a914979894cd805f938bac"
    sha256 cellar: :any_skip_relocation, ventura:        "adc1bc334357f7b3c5e7b5cfcb0d5726c641b2388b5744d610cc9c2969d1a58d"
    sha256 cellar: :any_skip_relocation, monterey:       "1d2aae3202ddc11878bbd4bf56a7181d3efa0e01ff6d8b5554afc0684dbd5249"
    sha256 cellar: :any_skip_relocation, big_sur:        "c5c84b754915fc431db087d0ead47730b75a596b764f2017cc71f0250461e142"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "075abb25353c8163674cf4e8f952e2ac40ce9883598cf9c08388bf30376d3dc6"
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
