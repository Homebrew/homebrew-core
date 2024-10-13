class Ratchet < Formula
  desc "Tool for securing CI/CD workflows with version pinning"
  homepage "https://github.com/sethvargo/ratchet"
  url "https://github.com/sethvargo/ratchet/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "e96135fa2acddade2707e2110d212b790c2a8d114a7ace8c5d25e9edbf83b7e9"
  license "Apache-2.0"
  head "https://github.com/sethvargo/ratchet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ebede08c8ce709ae39e9bc0f62c3544dad4abf496283830e0cd90f60a2453829"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4e904d78b0e6c10d5bf551a16ed857252d24ead2e9f516f26e461b69508fb196"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "579509ef8e3f5f20d185c8662620613b7aff6131a53f17d510068d91c7200370"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e42a349f8878e4ff5adb0daddba625e93488b1042123e4deb28e2eb0ed68154"
    sha256 cellar: :any_skip_relocation, sonoma:         "97aa1f256588276eba74c07ff6ee9c99fa19740c4bfb3b1c9e4bc4634a994111"
    sha256 cellar: :any_skip_relocation, ventura:        "56b68e942bb996298d508b5bf7c7d5233066397bb07f756d1ef5f8a69abbdfe8"
    sha256 cellar: :any_skip_relocation, monterey:       "b3d68a2ebc3886f694dc4771449230fe9bf57da781d7701692be1aa8a950f5b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9db3d5f28e3d08211699d07e23aae308a856acd2652177e9164354fa4efe563d"
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
