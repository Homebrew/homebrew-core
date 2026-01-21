class Slumber < Formula
  desc "Terminal-based HTTP/REST client"
  homepage "https://slumber.lucaspickering.me/"
  url "https://github.com/LucasPickering/slumber/archive/refs/tags/v4.3.1.tar.gz"
  sha256 "1d694870d76f4ac3a884e2af0d8e25380a809961a6702a6071f048f27b68171f"
  license "MIT"
  head "https://github.com/LucasPickering/slumber.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "357ea3c1aa6973ebf7544dc19cb62f8cca12733f359fbfa6a45e105761fc5591"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c126bd3d61ef92959ad49b41888e175099a5479bcdb9443771844ef1b7272ffd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25a000ce437ab48192674ac0d6591c79a2133687048fca59a94379271ba7dd34"
    sha256 cellar: :any_skip_relocation, sonoma:        "befc6b8263ab8730e8d9cf67b1cac99e9333bc8470c9caef1b57e80b3e2797f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ce5bbfc4d567f3ca3a4705e49320b543210df45c45f243b25474048ac7f16e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f77e856fc94b2b407ce03a0b1801c807a31051904f2853d5b899c9520b683da5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slumber --version")

    system bin/"slumber", "new"
    assert_match <<~YAML, (testpath/"slumber.yml").read
      profiles:
        example:
          name: Example Profile
          data:
            host: https://my-host
    YAML
  end
end
