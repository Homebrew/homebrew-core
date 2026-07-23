class Woxi < Formula
  desc "Interpreter for a subset of the Wolfram Language"
  homepage "https://github.com/ad-si/Woxi"
  url "https://github.com/ad-si/Woxi/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "49d24f0a497211494271ed5d442cb191cbac1d661105f0de510e31ccf41cff21"
  license "AGPL-3.0-or-later"
  head "https://github.com/ad-si/Woxi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8e1b93e89a2a15720db227cd939deff6106ad127ea55359037c906dfb9120f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da0621074d6955736702e6a96edd2dd18f5417a2313e47caf96477ddffc0487e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e62efd45631889eea0db1c61bcfc704184a94df9ecd7bc4549035084ed55cace"
    sha256 cellar: :any_skip_relocation, sonoma:        "5016f5e48a52c4c2c20eeee78cbb1e96272cc1b365aa1ddb74f8d34440b8ab08"
    sha256 cellar: :any,                 arm64_linux:   "55ba14485d34524aa3ed6949c84279a1796319be6f03130ef7c3d21afd9d486d"
    sha256 cellar: :any,                 x86_64_linux:  "e72a84101a97599bd136016d26d749dde38e85d398c76e57fe2374f02a78ac93"
  end

  depends_on "rust" => :build

  def install
    # Linker config for the upstream nix dev shell; lld is not available.
    rm ".cargo/config.toml"

    system "cargo", "install", "--bin", "woxi", *std_cargo_args
  end

  test do
    assert_equal "3", shell_output("#{bin}/woxi eval 'Plus[1, 2]'").strip
    assert_match version.to_s, shell_output("#{bin}/woxi --version")
  end
end
