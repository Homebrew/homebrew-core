class Yeet < Formula
  desc "Packaging tool that lets you declare build instructions in JavaScript"
  homepage "https://github.com/TecharoHQ/yeet"
  url "https://github.com/TecharoHQ/yeet/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "b87d344b56eb69aa72dce54c88397a77a8a24a9c013d1d81796d165d3000fe5d"
  license "MIT"
  head "https://github.com/TecharoHQ/yeet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab0f01e210c875e6e3d877ae90501750b237932f57fea21c1bc467e8a0f1eda7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab0f01e210c875e6e3d877ae90501750b237932f57fea21c1bc467e8a0f1eda7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ab0f01e210c875e6e3d877ae90501750b237932f57fea21c1bc467e8a0f1eda7"
    sha256 cellar: :any_skip_relocation, sonoma:        "d07b9541b0ab17a0c2bcead15f5c23c599b99dbf0cdbbc9201c19b820daacbc9"
    sha256 cellar: :any_skip_relocation, ventura:       "d07b9541b0ab17a0c2bcead15f5c23c599b99dbf0cdbbc9201c19b820daacbc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd694b054ccadce7cac78ca150fd568e2a8ec5b5a358fd2bb1ebf6464f4cf68a"
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
