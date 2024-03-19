class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.app/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v3.5.2.tar.gz"
  sha256 "0b9f8527ad8c5e4e4463336a28224a81c26166b0a1c8e8b4388cbc7f2569d052"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8330f32a8ebf0a7b722b9bcc6c2eb6e9f7e8526fb46dd4ac68f06bb3f5437dc7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5315457eb24b4bf28d1589cf35bcf98988a4a061b2301cf826e9abb04e007c1f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b32716eb58cce4aeb5285dcb866da5a04ca448a0b94d7d8405125b8462cb546e"
    sha256 cellar: :any_skip_relocation, sonoma:         "b0ec05dc1bbb7e353a311a22db51d7e164273385f842bbe552cb2a2f30b6d447"
    sha256 cellar: :any_skip_relocation, ventura:        "3f28e80bc753bde1eab322ab77e2bf3bd32bdea192ff8a3ddbb48d64aafd36e6"
    sha256 cellar: :any_skip_relocation, monterey:       "c7bf30ee4d8ba7a226b12bfa63af7fa65a5941b726fb2983f8eec74887b2aee4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d40291a4a01f3352fdbdab9acbc328fa33c080862c85f04bac43ea4df84f65e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    # Install shell completions
    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railwayapp #{version}", shell_output("#{bin}/railway --version").chomp
  end
end
