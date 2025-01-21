class Ratchet < Formula
  desc "Tool for securing CI/CD workflows with version pinning"
  homepage "https://github.com/sethvargo/ratchet"
  url "https://github.com/sethvargo/ratchet/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "0ca44bf4051e144a6df726950c7f056c419ffbafd1d0c3784046c9f6b865d453"
  license "Apache-2.0"
  head "https://github.com/sethvargo/ratchet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7c78e2858c6d74c4c47495170b42a1d8990b9852bb8f0c250efba163cbaab49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7c78e2858c6d74c4c47495170b42a1d8990b9852bb8f0c250efba163cbaab49"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c7c78e2858c6d74c4c47495170b42a1d8990b9852bb8f0c250efba163cbaab49"
    sha256 cellar: :any_skip_relocation, sonoma:        "f81010454c8f43536a6cc0ec15f55c3c18e3ff683943ee11ad87573878f6406c"
    sha256 cellar: :any_skip_relocation, ventura:       "f81010454c8f43536a6cc0ec15f55c3c18e3ff683943ee11ad87573878f6406c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4b8068b35a15a7104bde1ffe0188477a757863982ccb827a5694c2a217a0fb4"
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
