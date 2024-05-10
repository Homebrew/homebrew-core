class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://github.com/k1LoW/tbls/archive/refs/tags/v1.74.3.tar.gz"
  sha256 "8c0c0ab79089658fb5b82f7cff1855b838e5091ca936adf22fdd45382f1ebd54"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5cd8869704e59e711a5103e2be5d4b5ad747a02a945f5e6833ecf63be47cca91"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94fdf07541455374a9cb317ff1f9424b420ed2ecbca1093185625e2bc7ba3861"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa5c83327fc91a04a823cdbeba336f826e34de45113d25bcdaf4e1d14a969307"
    sha256 cellar: :any_skip_relocation, sonoma:         "748db62d313cf471a85f0689061dda981cd1d94fcc11a94c54728c1d0557fe08"
    sha256 cellar: :any_skip_relocation, ventura:        "5182ca624708b0c4576702c8c44e80d96d681278d198fc3d1061554747da2033"
    sha256 cellar: :any_skip_relocation, monterey:       "0ee105afd7ee96ee26079339b5ac76ccc6dec4670c63ea9f40fdd9e465770946"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15ff46d6268b106ebd894b16f181567368293f2585398dea738f1eaa1d0fbd82"
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
