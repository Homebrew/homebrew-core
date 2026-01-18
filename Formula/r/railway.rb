class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v4.25.2.tar.gz"
  sha256 "fb1ab7602d5e2016d7e5e4490c966da3ee47f66e2f4f1b76f47c08e1ee47aa37"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dafd5d6425f004955fae6d570cf520b7196df51ba863bcb3782f9550e4eed9ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abaaa562a8b6db15fb0b98ec46a64c2beeca63ace809ff7ec1ba33e0702130ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0fc36e3298649a2b10a3c7b4fa8e567493a59aacef5b475b78edc38f8cc6d44"
    sha256 cellar: :any_skip_relocation, sonoma:        "586d0df027f9b2aaa3be897121f7d6d1827a769529be1c2b3aaae3ae7b3f53a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7e53f9dfa4b5a52d1c27b56991226ec835c13c994b6ad11eb8661e67297ff4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a384ed630368fbaff2573804ae6e08855fe33bea0ae2b34a7a47f75cdc74a88"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railway #{version}", shell_output("#{bin}/railway --version").strip
  end
end
