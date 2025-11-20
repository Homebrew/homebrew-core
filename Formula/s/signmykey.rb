class Signmykey < Formula
  desc "Automated SSH Certificate Authority"
  homepage "https://signmykey.io/"
  url "https://github.com/signmykeyio/signmykey/archive/refs/tags/v0.8.9.tar.gz"
  sha256 "106a3a3d07aa2841d280ab378ce382a2bfca10101080936e2b02c4cc4e7d7392"
  license "MIT"
  head "https://github.com/signmykeyio/signmykey.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27f091d7952b6c13a343a1fa9977c509f2875a64becc8abdf4b33be742e4d208"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27f091d7952b6c13a343a1fa9977c509f2875a64becc8abdf4b33be742e4d208"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27f091d7952b6c13a343a1fa9977c509f2875a64becc8abdf4b33be742e4d208"
    sha256 cellar: :any_skip_relocation, sonoma:        "a461a5e9e52319c9c2c250e65ac57ce72df6ae095fd8170083cf7852dc8144cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a35476497be7495bb9b6a1897532f5f372b4f3ac8acaf7da80b50e6357d86f08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5dd151516a08ba5eb54ec55bd82b3fed379f2286b2ca5e00caf2a0e3a671bb62"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/signmykeyio/signmykey/cmd.versionString=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

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
