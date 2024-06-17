class Ratchet < Formula
  desc "Tool for securing CI/CD workflows with version pinning"
  homepage "https://github.com/sethvargo/ratchet"
  url "https://github.com/sethvargo/ratchet/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "a229b8cb3abc5300c438f78f35b9733ae4280ce59e0f8b5c7ec45f9b9c9b4683"
  license "Apache-2.0"
  head "https://github.com/sethvargo/ratchet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d5d9a4db858c6075f9b518c1b69624a4756eb8f645a9d44503304388b766b04d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c295360c84e6cd84062cfc51a516953250f762f4d95dfa0a01b8047d542511e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5747661ca78fcb07f035fbd6a663d4d91d5f21a534b949f99f8ba00900b88d8d"
    sha256 cellar: :any_skip_relocation, sonoma:         "89b2f6341d209acccd21d50ec94aa051776f0ff796cff893716156c54aefc5d3"
    sha256 cellar: :any_skip_relocation, ventura:        "93191c01af994c71cdd054d29c62706724349497f9bac975f5e739baa81b941a"
    sha256 cellar: :any_skip_relocation, monterey:       "7b84b170d361e753e3116f3e697b4305281200ac2e902f8c1b65c5dd33a14bc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4220faed06da3ac5aa63fdd1cef644ecf2742df3ec246fd37c18df6e6072384b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s
      -w
      -X=github.com/sethvargo/ratchet/internal/version.version=#{version}
      -X=github.com/sethvargo/ratchet/internal/version.commit=homebrew
    ]
    system "go", "build", *std_go_args(ldflags:)

    pkgshare.install "testdata"
  end

  test do
    cp_r pkgshare/"testdata", testpath
    output = shell_output(bin/"ratchet check testdata/github.yml 2>&1", 1)
    assert_match "found 4 unpinned refs", output

    output = shell_output(bin/"ratchet -v 2>&1")
    assert_match "ratchet #{version} (homebrew", output
  end
end
