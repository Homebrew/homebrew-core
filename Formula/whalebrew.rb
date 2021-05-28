class Whalebrew < Formula
  desc "Homebrew, but with Docker images"
  homepage "https://github.com/whalebrew/whalebrew"
  url "https://github.com/whalebrew/whalebrew.git",
      tag:      "0.3.1",
      revision: "372a6bcd5c154128f88d7a11d898dbf89ccca00e"
  license "Apache-2.0"
  head "https://github.com/whalebrew/whalebrew.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8353be040989f4bff9fd7817d07d4c2d74865700760101e7063b511bb8c760b9"
    sha256 cellar: :any_skip_relocation, big_sur:       "81bec2d30d79be2ae2102100ad99ae3c70d1b6729b4b93c32fe6ba743f9a6be8"
    sha256 cellar: :any_skip_relocation, catalina:      "f901fadcfb4bea48de0317c43b6cbbe292dd58a271f3c42a1731eee964fd6ba1"
    sha256 cellar: :any_skip_relocation, mojave:        "13cf645f882ac7cb4350af0b607ca0732c83a4260dc41a30b8cf37531c3d11d2"
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
