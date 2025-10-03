class Yeet < Formula
  desc "Packaging tool that lets you declare build instructions in JavaScript"
  homepage "https://github.com/TecharoHQ/yeet"
  url "https://github.com/TecharoHQ/yeet/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "0612a087867ef79e0737fcba46e2e87074a9520d5dba57e5e906b8a00594f518"
  license "MIT"
  head "https://github.com/TecharoHQ/yeet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3e5f2b58c00ec6b5eb907a1ac8d60f79a408fd7fe61973d4b81263b9a4aa0e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3dc5b3f4ea0d5edbf1dac8696a9d9e11bd334dcc3c9e7ae5b5f152e8f8d601fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3dc5b3f4ea0d5edbf1dac8696a9d9e11bd334dcc3c9e7ae5b5f152e8f8d601fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3dc5b3f4ea0d5edbf1dac8696a9d9e11bd334dcc3c9e7ae5b5f152e8f8d601fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "18f56dcbe60a642672a190b31beb9ae884b0bbdb040998582a008241b209eab3"
    sha256 cellar: :any_skip_relocation, ventura:       "18f56dcbe60a642672a190b31beb9ae884b0bbdb040998582a008241b209eab3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc534d2cf20d04fd6db81eff080e71c3457bf1e95d8c3d1b56363941de6a3ec0"
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
