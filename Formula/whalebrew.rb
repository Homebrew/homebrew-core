class Whalebrew < Formula
  desc "Homebrew, but with Docker images"
  homepage "https://github.com/whalebrew/whalebrew"
  url "https://github.com/whalebrew/whalebrew.git",
      tag:      "0.3.1",
      revision: "372a6bcd5c154128f88d7a11d898dbf89ccca00e"
  license "Apache-2.0"
  head "https://github.com/whalebrew/whalebrew.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e631a8b2926e1889419048610e4cf971afe61941e03525a1e5658a1da05b10e6"
    sha256 cellar: :any_skip_relocation, big_sur:       "b895a6a75c4018afe7513cb505faddc40cbfb2adc147b9d392d2d78228da5745"
    sha256 cellar: :any_skip_relocation, catalina:      "76af29939b18de9fa8814ac0a1e22ed180f71ecbea55656bd76057a3f6c133cf"
    sha256 cellar: :any_skip_relocation, mojave:        "c1ab9e50235621d22b1176896ab682868aeddd81516a4374c485d217c0fb6b55"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"whalebrew", "."
  end

  test do
    output = shell_output("#{bin}/whalebrew install whalebrew/whalesay -y", 255)
    assert_match "Cannot connect to the Docker daemon", output
  end
end
