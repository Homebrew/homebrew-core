class Tailspin < Formula
  desc "Log file highlighter"
  homepage "https://github.com/bensadeh/tailspin"
  url "https://github.com/bensadeh/tailspin/archive/refs/tags/2.2.0.tar.gz"
  sha256 "afa7ffa24d47d6266ea96b06ca9b30cc9898095dd4d077e8fe9618ace96c6b89"
  license "MIT"
  head "https://github.com/bensadeh/tailspin.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db53ddab0e0dfbd261b74f9286b227ea4d87688857733c9b602973967392e78f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ddc28d4b5dcb22ed7a48469522c47b0909bf7b9b5238f9b41d5151fdc511051"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55b8a7a3d03ffec7ddbf123885b104a293e53d5f040c574ed1aa7d9b45a0e944"
    sha256 cellar: :any_skip_relocation, sonoma:         "a8cda87f5dade0030637c0c321f5a5a0028e7bcd40fd3844132e9717fe240ea7"
    sha256 cellar: :any_skip_relocation, ventura:        "e23bb0fdaba79e93e00395f271f6ea2f2fc56955ccc42b0a9bcccf85b968bb74"
    sha256 cellar: :any_skip_relocation, monterey:       "1979fd56533d3d5f148311acc016fadcb787686899743682ab4fc101e096ddfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20f0d0915b1ea6cea327063d579209480031ca1aada8cccc8c4560d4b7989a09"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"tspin", "--z-generate-shell-completions")
    man1.install "man/tspin.1"
  end

  test do
    output = shell_output("#{bin}/tspin --tail 2>&1")

    expected = if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      ""
    else
      "Missing filename"
    end
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}/tspin --version")
  end
end
