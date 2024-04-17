class Ratchet < Formula
  desc "Tool for securing CI/CD workflows with version pinning"
  homepage "https://github.com/sethvargo/ratchet"
  url "https://github.com/sethvargo/ratchet/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "e6d418075866a0c1040ef36a009cb4f8d2ed0edf6f4b5cb0041c3d076c6a349a"
  license "Apache-2.0"
  head "https://github.com/sethvargo/ratchet.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1cccac2d1277f930cbb1a0864a4bbed8d06eccda93b0ad097397248e05889255"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44531e78f2f4d6364d9fbf2cb0d5c7f365cbcaf33d223f471a3e6fe0d8dbc972"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca10450bc9b638951403ab1c0d02a658af4377339f0bce317f48f201e4a027d1"
    sha256 cellar: :any_skip_relocation, sonoma:         "a2770c52767c913f7a762e4c10c19400563f8448ee0291d9e5bfef7da54b534f"
    sha256 cellar: :any_skip_relocation, ventura:        "fdc70af633ea143ee3e2b0bccdd8a4c05d0e9bc9ad3a03eaa732fe41aa85718d"
    sha256 cellar: :any_skip_relocation, monterey:       "72844ef394d8418a91a018b74209a08a089ab1c46a005461fe3207bd191a0974"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d46d0be31aabe65fd97e19586c48f5d039aa825a8bf40893220d74121fb08acf"
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
