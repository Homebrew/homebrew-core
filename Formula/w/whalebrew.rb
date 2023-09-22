class Whalebrew < Formula
  desc "Homebrew, but with Docker images"
  homepage "https://github.com/whalebrew/whalebrew"
  url "https://github.com/whalebrew/whalebrew.git",
      tag:      "0.4.1",
      revision: "8137e562f38ce32d425df4a3676143c2d631d0f1"
  license "Apache-2.0"
  head "https://github.com/whalebrew/whalebrew.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "648b3a384d987ff824c9e165732c722c4bb000fc202f49658b08228c664ec855"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d46a38aeb20d1796c51ac11de14bf84a80f063953891042b265c72284f63e3e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c79a962ae505334ed9928409892cfb64bdb5faabf61812fdb7bc3b67367e3d27"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8287404bc73e04a949d09c8750ea28a33b8ca72e1201d9027a471f6a9bc457a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "9d4b5b85e37efbf4a5e7dc7ae939a3f9579b7f3ddd04273096ebe715e3441409"
    sha256 cellar: :any_skip_relocation, ventura:        "d3d58156c45770291a5d380c55eb76315845be7fbf1069bda91b9fed0b0acb63"
    sha256 cellar: :any_skip_relocation, monterey:       "65f42c7c8913cde5493c499072546e315ca2ae62d93961f95097e20bb682273b"
    sha256 cellar: :any_skip_relocation, big_sur:        "62f017b4103e3b3e17e31855dbb4dc56d8e851bc88fb83e5c6e47bdf2411cf4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b46a0b822da1ba80286fc14697e18f1c64a69a305a58d3b7532150ed9745967"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"whalebrew", "completion")
  end

  test do
    output = shell_output("#{bin}/whalebrew install whalebrew/whalesay -y", 255)
    assert_match(/connect to the Docker daemon|operation not permitted/, output)
  end
end
