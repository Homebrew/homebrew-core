class Riff < Formula
  desc "Diff filter highlighting which line parts have changed"
  homepage "https://github.com/walles/riff"
  url "https://github.com/walles/riff/archive/refs/tags/3.6.1.tar.gz"
  sha256 "d360058f0e51d162235307498485f92dc57518877f5646f00521b97e92957bbe"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08f487befc18a19c17342e9981152de7c15d73014a99b2a3f414f071521b7b91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99bff9a830876f3566bd2bc054b96cd6938d521235327f1f12723d103d5ab436"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c73c8cd55833b760109d8e421b653ac8c05fc841b5f9f07bfe3e845df985de8"
    sha256 cellar: :any_skip_relocation, sonoma:        "439db215e250db18856f7efe62bc33dea7be3e1f5bbf9be1bc377e799f5d6d5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5920fc8b61db3bf10d058e65ec057d7838ef2b7cea135a0b7b857992bf40e1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51692f8697578dc0a6d169cdf0389103cf215289f71d46854bac396d465dd8f2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_empty shell_output("#{bin}/riff /etc/passwd /etc/passwd")
    assert_match version.to_s, shell_output("#{bin}/riff --version")
  end
end
