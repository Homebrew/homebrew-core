class Srgn < Formula
  desc "Code surgeon for precise text and code transplantation"
  homepage "https://github.com/alexpovel/srgn"
  url "https://github.com/alexpovel/srgn/archive/refs/tags/srgn-v0.14.0.tar.gz"
  sha256 "b6219c19214ad932b5df67c8ee00f32755014bf5ea2a1b6b57c6913c3124d202"
  license "MIT"
  head "https://github.com/alexpovel/srgn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89afca697ec0afb55afbe31f14c294cc901d17c9abba1cb5f2d72f8e8b4f03b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0733ebd9f017acbd960e332e97d155e2f07a3b9d8ec262bc07d5cbeb7b8dfba9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "62dc6bf77bf3db36d74ca388ece0329272152ddf3518b7b7dce8dfa505a4e245"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6117f3f6574d78d26834664f9cba9ad4ce8a74329dd8605010faf92ef8a8963"
    sha256 cellar: :any_skip_relocation, ventura:       "958ca75e594858d8a4a2eacee9cf226d42555314de543b5f9f31008725aab742"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e35a1375edadf7c3db18100f0b369f90d55d863b1fabaaaa731df1f148290fa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d47e9c81e12337fb3c886452a2c226348c711eb480a4d69f03fc3e11c24a99c3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"srgn", "--completions")
  end

  test do
    assert_match "H____", pipe_output("#{bin}/srgn '[a-z]' -- '_'", "Hello")

    test_string = "Hide ghp_th15 and ghp_th4t"
    assert_match "Hide * and *", pipe_output("#{bin}/srgn '(ghp_[[:alnum:]]+)' -- '*'", test_string)

    assert_match version.to_s, shell_output("#{bin}/srgn --version")
  end
end
