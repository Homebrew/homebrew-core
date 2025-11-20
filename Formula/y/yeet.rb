class Yeet < Formula
  desc "Packaging tool that lets you declare build instructions in JavaScript"
  homepage "https://github.com/TecharoHQ/yeet"
  url "https://github.com/TecharoHQ/yeet/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "857b373f8f0cb88474f16da7df2142b2d1b5f7d62de196178ea5ab22567e808d"
  license "MIT"
  head "https://github.com/TecharoHQ/yeet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c9e8aaadf45a0a469e8b105c7bc896b9fdc6116e5b2ba4b2889b2b44cbf62a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c9e8aaadf45a0a469e8b105c7bc896b9fdc6116e5b2ba4b2889b2b44cbf62a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c9e8aaadf45a0a469e8b105c7bc896b9fdc6116e5b2ba4b2889b2b44cbf62a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "42b32caa0459544dbdd09a36b9176798e3fcd3d7a192d7dd6a267ded3a68e1e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3dad7ec5c66f2b644c1fd0edff0d1ba9dafa750573e2b2e62883625cf82e960a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fd08161050e397290b7d649eb1ff41624202573ebb9f162312278b72521c7f0"
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
