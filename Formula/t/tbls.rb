class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://github.com/k1LoW/tbls/archive/refs/tags/v1.70.2.tar.gz"
  sha256 "81afd3df26911b3b8aad0ebf8427445a8503f2b38c441639fec9ec1a5d1837cd"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b0d0763aa3016c1eac5f3fec35616257ecb11823855e7d7612bb3bb53b603455"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ccaaca70aa31a4733c9bab9abcb051f8715a13e1e7b63804aa1941e28e71a55"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8401d07d17cd7bc0ad7d77e7f235ae1e393ea6bf8af8163d7e78060d9001426e"
    sha256 cellar: :any_skip_relocation, sonoma:         "f957c936b39701782b3511c8ef453080ae20ff17d3cab23425345a526cf371c4"
    sha256 cellar: :any_skip_relocation, ventura:        "e4a681402d0c2ba69178a97d75ab68e20a00b60b31ee0a618ea6c1ba742dd09d"
    sha256 cellar: :any_skip_relocation, monterey:       "fde6ceef6bad058e0a6e6f0a6a5a6643058f6007fbd9df76e67f726200bb02d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "201564bb0b56a614c8220f80fb21fa794c56dfd2fef555350c1da6ea491bae33"
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
