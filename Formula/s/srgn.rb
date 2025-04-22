class Srgn < Formula
  desc "Code surgeon for precise text and code transplantation"
  homepage "https://github.com/alexpovel/srgn"
  url "https://github.com/alexpovel/srgn/archive/refs/tags/srgn-v0.13.6.tar.gz"
  sha256 "7786ef149d990cd70c5df541e066aeb79aff7d7fa60e4c59e92ccebf8e606b5b"
  license "MIT"
  head "https://github.com/alexpovel/srgn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aee23758b050640fcd4a4aaf2497f46e3bd8810bac75c6045f07eec8c3ba242e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ecb27613159d40d6e53ae40dd2d6a3ac1cfd9df1d1da21c799af35802246b81"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9a5ab99bcbea2c4a1aaa3bc35653938fb62815f7cb2ac4a269c7a19531819e41"
    sha256 cellar: :any_skip_relocation, sonoma:        "6372bbaab4b1b8f8456c2fb23c217a57ca16ab40f8f45a0bcff64c4ec9c68391"
    sha256 cellar: :any_skip_relocation, ventura:       "66199b4bf91c3c3b690595ade9d5917cf5fc7e739520a812fbe950538d9c98d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d569e847346a9666f183b143d24cb9724eb8aeb6bed381fc0b12c188971c86e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17c815e9b6270bbfb47dfe758a644eb66784898cacb0074441295421914cf1e6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"srgn", "--completions")
  end

  test do
    assert_match "H____", pipe_output("#{bin}/srgn '[a-z]' '_'", "Hello")

    test_string = "Hide ghp_th15 and ghp_th4t"
    assert_match "Hide * and *", pipe_output("#{bin}/srgn '(ghp_[[:alnum:]]+)' '*'", test_string)

    assert_match version.to_s, shell_output("#{bin}/srgn --version")
  end
end
