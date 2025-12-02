class Tldx < Formula
  desc "Domain Availability Research Tool"
  homepage "https://brandonyoung.dev/blog/introducing-tldx/"
  url "https://github.com/brandonyoungdev/tldx/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "4e72535ad99396ad1f4d2322024f317fd5d3f05d3e82a645fa403d3ce95b3729"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76759fb677db0005af23b2da332e69128e055472d504ba29b1223b9abd72ce1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84bddde265a819e8ca9466fa889b68ce364cc362c83d3c3f18e5491025bca97f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84bddde265a819e8ca9466fa889b68ce364cc362c83d3c3f18e5491025bca97f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "84bddde265a819e8ca9466fa889b68ce364cc362c83d3c3f18e5491025bca97f"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a1dbaa3bf0602624c72c21bbf828f50717d921de9891ffee378696a60ebe533"
    sha256 cellar: :any_skip_relocation, ventura:       "4a1dbaa3bf0602624c72c21bbf828f50717d921de9891ffee378696a60ebe533"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "def1739918a5766e8ee7b466e9b84b6b6abdd9c93b7561da1d0d8e817a924768"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc23b2e244244574127afec5b6194eb2d2ed206dd0e3fe42fb5f054154a9096f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/brandonyoungdev/tldx/cmd.Version=#{version}")
  end

  test do
    assert_match "brew.sh is not available", shell_output("#{bin}/tldx brew --tlds sh")

    assert_match version.to_s, shell_output("#{bin}/tldx --version")
  end
end
