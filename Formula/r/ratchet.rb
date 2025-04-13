class Ratchet < Formula
  desc "Tool for securing CI/CD workflows with version pinning"
  homepage "https://github.com/sethvargo/ratchet"
  url "https://github.com/sethvargo/ratchet/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "38451e56b4a59268d67c2cb3cfdeb14f658d5ce4655b1d74256ca6e547fbf525"
  license "Apache-2.0"
  head "https://github.com/sethvargo/ratchet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e45d4082d0b0e628bd3b2399cf145726cecf75aed76637a3c794c3101de55205"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e45d4082d0b0e628bd3b2399cf145726cecf75aed76637a3c794c3101de55205"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e45d4082d0b0e628bd3b2399cf145726cecf75aed76637a3c794c3101de55205"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f640387cbba1cf2f0702a5d0c2d407e5bed3acf52cfb60b1b9e5aef1f428e5c"
    sha256 cellar: :any_skip_relocation, ventura:       "2f640387cbba1cf2f0702a5d0c2d407e5bed3acf52cfb60b1b9e5aef1f428e5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "449f97e781e34e74988859434ae1f64f68cc4c44b79748d6f4312d4c168b3e15"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s
      -w
      -X=github.com/sethvargo/ratchet/internal/version.version=#{version}
      -X=github.com/sethvargo/ratchet/internal/version.commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    pkgshare.install "testdata"
  end

  test do
    cp_r pkgshare/"testdata", testpath
    output = shell_output(bin/"ratchet check testdata/github.yml 2>&1", 1)
    assert_match "found 5 unpinned refs", output

    output = shell_output(bin/"ratchet -v 2>&1")
    assert_match "ratchet #{version}", output
  end
end
