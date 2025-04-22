class Tbls < Formula
  desc "CI-Friendly tool to document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://github.com/k1LoW/tbls/archive/refs/tags/v1.85.0.tar.gz"
  sha256 "3f37add600fe590178a5225ca15bc72c3fb61f9e69098c8ff3d8491787e69a1a"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "965a3be12fb987f51c3d45842b05dcfddd4ef1df3a5a10f242b1c63d875d47e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25dabf2612b853923b25209d4814c43884cd54092641f69582c7c93a9e9ad016"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "18ee94f771cf3411b82d1dadf5b665bc8f422cda3a545989722b38aded24d66d"
    sha256 cellar: :any_skip_relocation, sonoma:        "84874ed69e80770859d3e67166b3d8e3c11730f1b21eeedc919d3032d8eca0dc"
    sha256 cellar: :any_skip_relocation, ventura:       "2ef6f4dc17972199490747e760f3e5bfaa21ebf44284d4a6b7177671072a3a16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8a84ee5154f971e03cee186cd5be4b40901206f6d9189738ee5a2f4941487f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6481da6b8d679870eb9b77cb78711a1ba68bde931ceba4ced466043151f18755"
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
    assert_match "unsupported driver", shell_output(bin/"tbls doc", 1)
    assert_match version.to_s, shell_output(bin/"tbls version")
  end
end
