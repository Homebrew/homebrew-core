class Squealer < Formula
  desc "Scans Git repositories or filesystems for secrets in commit histories"
  homepage "https://github.com/owenrumney/squealer"
  url "https://github.com/owenrumney/squealer/archive/refs/tags/v1.2.4.tar.gz"
  sha256 "8ac30e914780f2f7f495afd93a20d0b7835cee712577ef680f7a2ec9d276758e"
  license "Unlicense"
  head "https://github.com/owenrumney/squealer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e4da7568fde2169f0fb08a9f0d15e997be2fcf1004fea517389e7608bca79d13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2a7041bdb10db0ffa95f42b76a87bd830d7b950ba9848379a7f0af586d0a0ecc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2943ac5832058d7766aa71a7e986a05c759a21c6b3d18febf7e95f20a7489a7b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c59845814f814552514911196624bdb2a061ba5b0cb75a9181fe8e6552e2d422"
    sha256 cellar: :any_skip_relocation, sonoma:         "d40545360874e17e53ef0c6e0a04524d54fff27bd563bcb6b3cb9ccf7fd64ada"
    sha256 cellar: :any_skip_relocation, ventura:        "439566e9aac89dcaf4282ee347f63cee9e92ecae438141b8e0ac25bdb43f8a3f"
    sha256 cellar: :any_skip_relocation, monterey:       "deac7c42fe6d50c7ffc7ea841a7269829b7d334e8d3d5fcc55bdd380d4a3859e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e86fb9ce09801e79caab1090ad564baf942794d92624f8bab93cb7db83c1922"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/owenrumney/squealer/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/squealer"
  end

  test do
    system "git", "clone", "https://github.com/owenrumney/woopsie.git"
    output = shell_output("#{bin}/squealer woopsie", 1)
    assert_match "-----BEGIN OPENSSH PRIVATE KEY-----", output
  end
end
