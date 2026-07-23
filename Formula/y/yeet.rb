class Yeet < Formula
  desc "Packaging tool that lets you declare build instructions in JavaScript"
  homepage "https://github.com/TecharoHQ/yeet"
  url "https://github.com/TecharoHQ/yeet/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "c76bd0513c4e7601c1181f99565d2015329622d7cb35dfbde06f40b020f66c90"
  license "MIT"
  head "https://github.com/TecharoHQ/yeet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b7d0ae322fc55da7ae91d4e9a8216c5794e59b2da1985035a6b3df06178787ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7d0ae322fc55da7ae91d4e9a8216c5794e59b2da1985035a6b3df06178787ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7d0ae322fc55da7ae91d4e9a8216c5794e59b2da1985035a6b3df06178787ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "50c5e4231d0606dd7925dd7d13d6b58012e9f0a3016f2c49e21df6203dd8559b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa12094fd192cddec58727aad205f5c3ea3a1d8aeed846cd42cd2d7f42e04293"
    sha256 cellar: :any,                 x86_64_linux:  "263b9afeab43805d8d02278fcf30e8fe8674188606bd947f7decf8167b6dda52"
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
