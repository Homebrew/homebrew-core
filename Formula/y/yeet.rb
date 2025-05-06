class Yeet < Formula
  desc "Packaging tool that lets you declare build instructions in JavaScript"
  homepage "https://github.com/TecharoHQ/yeet"
  url "https://github.com/TecharoHQ/yeet/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "157bd064defd2e47c4a0f85fdee92fda51548a27b3a273194ef4dd315147b8e3"
  license "MIT"
  head "https://github.com/TecharoHQ/yeet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd2fe022c2cc94d2cb6997c3eccf7ff7b7ef738f1509a1b69737254b1a250f35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd2fe022c2cc94d2cb6997c3eccf7ff7b7ef738f1509a1b69737254b1a250f35"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bd2fe022c2cc94d2cb6997c3eccf7ff7b7ef738f1509a1b69737254b1a250f35"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8a6ca7d3a6a25c07ec08c2177e32ff3fe978e7986d103eb49856728898021f4"
    sha256 cellar: :any_skip_relocation, ventura:       "d8a6ca7d3a6a25c07ec08c2177e32ff3fe978e7986d103eb49856728898021f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2dd5767d76731ba8711a36e15c90a326218e8ca2bfa075266af81c7d644a85a5"
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
