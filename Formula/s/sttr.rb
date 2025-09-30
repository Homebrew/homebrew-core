class Sttr < Formula
  desc "CLI to perform various operations on string"
  homepage "https://github.com/abhimanyu003/sttr"
  url "https://github.com/abhimanyu003/sttr/archive/refs/tags/v0.2.27.tar.gz"
  sha256 "72e1c173843e42b3e719843f2825bf1d2a20e3167016c5962158365969e38df2"
  license "MIT"
  head "https://github.com/abhimanyu003/sttr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51940cef9aa765fde81e838370403f945841450d17ec2a485dd7f142f99efa28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d015f628e3b46037094749ffa2c33d891137b394a86acf21bd5ad7d58552572b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d015f628e3b46037094749ffa2c33d891137b394a86acf21bd5ad7d58552572b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d015f628e3b46037094749ffa2c33d891137b394a86acf21bd5ad7d58552572b"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c842e04ea0c7792a2fe6df9ae3097eeaa744721e928e0743a6e892aae36addd"
    sha256 cellar: :any_skip_relocation, ventura:       "8c842e04ea0c7792a2fe6df9ae3097eeaa744721e928e0743a6e892aae36addd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51dd4666518f8b010cbbb6f1f2c3d05afe6c1729bbc28cd3b4ba3f2557a855cd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sttr version")

    assert_equal "foobar", shell_output("#{bin}/sttr reverse raboof")

    output = shell_output("#{bin}/sttr sha1 foobar")
    assert_equal "8843d7f92416211de9ebb963ff4ce28125932878", output

    assert_equal "good_test", shell_output("#{bin}/sttr snake 'good test'")
  end
end
