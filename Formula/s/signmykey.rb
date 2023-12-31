class Signmykey < Formula
  desc "Automated SSH Certificate Authority"
  homepage "https://signmykey.io"
  url "https://github.com/signmykeyio/signmykey/archive/refs/tags/v0.8.5.tar.gz"
  sha256 "cd0eb24909ad531db6889c7b94450f0dfeb1c949db6ab60dbe60b9844ad1df47"
  license "MIT"
  head "https://github.com/signmykeyio/signmykey.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e82ec90d1b327450e134d0d164c2d80cd5cdfd409a27f0e96e712df87895bfa6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a08dba6d4f40f839eef53409697741c7a458bb57e37c6d55fc033b6e668810d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9646924fb3ef74816bf124f6b04da1e3de2f1d2aa4c8e74f0a3dda310f8798ab"
    sha256 cellar: :any_skip_relocation, sonoma:         "67d0b86a654933424c8fecd5f55b1c8fe821d6a6728ea706701a92d398fef745"
    sha256 cellar: :any_skip_relocation, ventura:        "c8583b19395e14035580a5b802528745c82dd7fd34f3f51e8d6864acc6dcb1f0"
    sha256 cellar: :any_skip_relocation, monterey:       "59791f5b158790ebd635ae6cef7d03dbf1d3efcd482d528dfbcdd87ca8c3f531"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4605658b36ad8b1c067cd657b5967da8ba9b4e9a469c400149760adba366913b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/signmykeyio/signmykey/cmd.versionString=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"signmykey", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/signmykey version")

    require "pty"
    stdout, _stdin, _pid = PTY.spawn("#{bin}/signmykey server dev -u myremoteuser")
    sleep 2
    assert_match "Starting signmykey server in DEV mode", stdout.readline
  end
end
