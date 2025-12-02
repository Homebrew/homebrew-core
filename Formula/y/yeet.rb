class Yeet < Formula
  desc "Packaging tool that lets you declare build instructions in JavaScript"
  homepage "https://github.com/TecharoHQ/yeet"
  url "https://github.com/TecharoHQ/yeet/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "c27f50d0b35180feea156f8c36e8ccd40959ef83aa303049a3f19fdd86914f7b"
  license "MIT"
  head "https://github.com/TecharoHQ/yeet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8bd1f148b7ab439880382186e01053c7328faf48fc31e516d3e2219a2914dbd6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8bd1f148b7ab439880382186e01053c7328faf48fc31e516d3e2219a2914dbd6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8bd1f148b7ab439880382186e01053c7328faf48fc31e516d3e2219a2914dbd6"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8e39b4014eabde128677677002de5918e80af8cd776d7a75a40afae9c2aa6e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81aaede03fd120dc85d7ded8a3efc832c378a53335775b81efa62dcc4edfcfd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c3e9b479d7a14d8aea22105e7286d145b6dc1edcbe9dd4c420bcf2e1d764590"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/TecharoHQ/yeet.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/yeet"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yeet -version")

    output = "open yeetfile.js: no such file or directory"
    assert_match output, shell_output("#{bin}/yeet 2>&1", 1)
  end
end
