class Quran < Formula
  desc "Print Qur'an chapters and verses right in the terminal"
  homepage "https://git.hanabi.in/quran-go"
  url "https://git.hanabi.in/repos/quran-go.git",
      tag:      "v1.0.1",
      revision: "c0e271a69a2e817bf75c8ad79a1fc93aa1b868c9"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1aa25892303cecb44013a7c2bdeab76894cc726da7cc317131d167ef0f4fbedc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b3d32b81de6b07f52c027b032166df42922f3123582e6b2c734d795405867fc5"
    sha256 cellar: :any_skip_relocation, monterey:       "ab7e9bb1a4742b4f7783fee1144cb7ebc2954c4ecfa7b52f40d73c841e7ec4db"
    sha256 cellar: :any_skip_relocation, big_sur:        "e57655e977854a53f6f8712f9bf66eecb31daec7bbf144d9b80922ad10d5a647"
    sha256 cellar: :any_skip_relocation, catalina:       "f41e4287511541da638da95a970a646c0547d5da27bc8e5aa10fda024873c1d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffa496599e16b50087432710d43a26101fa92eda772535de0d9349410b51cb78"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "src/main.go"
  end

  test do
    op = shell_output("#{bin}/quran 1:1").strip
    assert_equal "In the Name of Allah—the Most Compassionate, Most Merciful.", op
  end
end
