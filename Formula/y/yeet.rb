class Yeet < Formula
  desc "Packaging tool that lets you declare build instructions in JavaScript"
  homepage "https://github.com/TecharoHQ/yeet"
  url "https://github.com/TecharoHQ/yeet/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "2ea7d2bb1a37dbb401fdee0b304228b5165caad65e100423504de21aaaece15d"
  license "MIT"
  head "https://github.com/TecharoHQ/yeet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a73b809122ba4331e99f81aa0276ce757ef59f83734c5a9a6c1c8e0e75e6a0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a73b809122ba4331e99f81aa0276ce757ef59f83734c5a9a6c1c8e0e75e6a0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a73b809122ba4331e99f81aa0276ce757ef59f83734c5a9a6c1c8e0e75e6a0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "714bfb59a73c5db4ea5d65240ec2fe72e429f974b5aea08ee9e1de2b4f362d73"
    sha256 cellar: :any_skip_relocation, ventura:       "714bfb59a73c5db4ea5d65240ec2fe72e429f974b5aea08ee9e1de2b4f362d73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65de6d176c3167324e68370c1ba9cd7b8c6ddae2a1b3342c151783e9e8a619b5"
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
