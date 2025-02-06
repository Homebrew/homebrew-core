class Ratchet < Formula
  desc "Tool for securing CI/CD workflows with version pinning"
  homepage "https://github.com/sethvargo/ratchet"
  url "https://github.com/sethvargo/ratchet/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "6072b00cc01c90aed978ea7e49de9b5e3f73a3ab663cd5b9e594b95c3cf45d3a"
  license "Apache-2.0"
  head "https://github.com/sethvargo/ratchet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "731e388794c5bf52887d80293db50d77ac4ce187ae03cb3464b581e4c97e53a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "731e388794c5bf52887d80293db50d77ac4ce187ae03cb3464b581e4c97e53a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "731e388794c5bf52887d80293db50d77ac4ce187ae03cb3464b581e4c97e53a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e279a44bed6b30f883e9c7e09bd1d245dd5fb0afd326d14d8bbf5910f085a04"
    sha256 cellar: :any_skip_relocation, ventura:       "6e279a44bed6b30f883e9c7e09bd1d245dd5fb0afd326d14d8bbf5910f085a04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f9099d35c16f164c8acf2789eb8abc9f8ab153164c3068db45ff57c59ed0a70"
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
