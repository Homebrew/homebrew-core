class Yeet < Formula
  desc "Packaging tool that lets you declare build instructions in JavaScript"
  homepage "https://github.com/TecharoHQ/yeet"
  url "https://github.com/TecharoHQ/yeet/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "fc12f4f700d0a87575a7f171b8ccb97a58f8d55695550a11c600b17ac0a6fbd5"
  license "MIT"
  head "https://github.com/TecharoHQ/yeet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0608d7cdfadff69e42406d3c3742c6e236f9b0d135b00b4f6269918e5b0132df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0608d7cdfadff69e42406d3c3742c6e236f9b0d135b00b4f6269918e5b0132df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0608d7cdfadff69e42406d3c3742c6e236f9b0d135b00b4f6269918e5b0132df"
    sha256 cellar: :any_skip_relocation, sonoma:        "86e3e83025853545d61541d86967be540b517c843085d64e0710ce031550dcda"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7f089624eedad9076836ccebd32d112b4f395fa1e6cea88ddcd3e61b64a8a37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e181fbc4ccfc8bd4078c732a0083ed3cd9a2d7b978109349b2dceda9f5e25d4f"
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
