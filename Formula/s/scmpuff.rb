class Scmpuff < Formula
  desc "Adds numbered shortcuts for common git commands"
  homepage "https://mroth.github.io/scmpuff/"
  url "https://github.com/mroth/scmpuff/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "4478a53ff16d70ca433d21a66f7e3532631f43ecd64a1fbaf0a933aa7cbd2df4"
  license "MIT"
  head "https://github.com/mroth/scmpuff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d9335d31cb6a4eaf7629c3d66e7af096efa7a255ce07ca45980b8c6ead74ac3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5cb1859e64a1c7d5ed9865ef08504813424a0d372720f165f22eb8cdcf9d28c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5cb1859e64a1c7d5ed9865ef08504813424a0d372720f165f22eb8cdcf9d28c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5cb1859e64a1c7d5ed9865ef08504813424a0d372720f165f22eb8cdcf9d28c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "0cb10c56e24bf596383ce3c2221b14cd37f70d886563b873073a0b7e49300f97"
    sha256 cellar: :any_skip_relocation, ventura:       "0cb10c56e24bf596383ce3c2221b14cd37f70d886563b873073a0b7e49300f97"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b259cbbf0237281e162eb941a0457b9fa17cceb5bc8ab5d8459fce85fbe77d25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23567d3e31ff884250b533cbf175f24cdb22265d3b42bde108fe3722aa99a302"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.builtBy=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/scmpuff --version 2>&1")

    ENV["e1"] = "abc"
    assert_equal "abc", shell_output("#{bin}/scmpuff expand 1").strip
  end
end
