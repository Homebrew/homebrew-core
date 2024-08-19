class Tailspin < Formula
  desc "Log file highlighter"
  homepage "https://github.com/bensadeh/tailspin"
  url "https://github.com/bensadeh/tailspin/archive/refs/tags/3.0.2.tar.gz"
  sha256 "6a54127187fc894ca5c58d0f65108769c9c2ac022185f29b87818aaa4150ed0b"
  license "MIT"
  head "https://github.com/bensadeh/tailspin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "74cfd7eeee1d27b0eb0b72b9b339081a39166fa2ab8c3ec285bef9437a9373de"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19a98f9d0dcbb46455faad29e2bb164218cc6802900d969f3043ec1bbc29e6f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "876addcaf0fb35e59b2b1ffdd87265ed5b5ebc09c2d3386d0efc8904a4c6ea70"
    sha256 cellar: :any_skip_relocation, sonoma:         "bb7b6eabae1ca696b806063e118ef03516e602dd98c33f468d97dbca05225ec1"
    sha256 cellar: :any_skip_relocation, ventura:        "d4c9467ed94777ce46f04e711d9ed548a752138a0213570ea49d615257b68608"
    sha256 cellar: :any_skip_relocation, monterey:       "35c4b8a87d7906f5285dccc375f69004da81a15027d8de8ac956e3386aa2244f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a0adb361df9f9f402c6a6f2715e502a332a615a09a1ed66f497e4470fe9a893"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"tspin", "--z-generate-shell-completions")
    man1.install "man/tspin.1"
  end

  test do
    output = shell_output("#{bin}/tspin --start-at-end 2>&1")

    expected = if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      ""
    else
      "Missing filename"
    end
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}/tspin --version")
  end
end
