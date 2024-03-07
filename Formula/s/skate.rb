class Skate < Formula
  desc "Personal key value store"
  homepage "https://github.com/charmbracelet/skate"
  url "https://github.com/charmbracelet/skate/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "e982348a89a54c0f9fafe855ec705c91b12eb3bb9aceb70b37abf7504106b04e"
  license "MIT"
  head "https://github.com/charmbracelet/skate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3d5f184617c11e79eeb8057d4f5c013cb18e6353e16b86b7adbda659ab6e76b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0dc2300accf767f75eec55e607b41d0d8ce896d1ace148dbe503c6b5791229fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ead33bf722be5c46713800d8242f20c29671b0db5afce776743f80a97e040b85"
    sha256 cellar: :any_skip_relocation, sonoma:         "c15917175e853b12fc11aa51c5bbc8100119009abeaa7597c8ce73eb90170642"
    sha256 cellar: :any_skip_relocation, ventura:        "91570c6f8ebf55becc3ffa0c5f257f0aab50d53f33515710c4c851c4e673aec4"
    sha256 cellar: :any_skip_relocation, monterey:       "2ee465b3093a611b4dea651d02280bc4d886565a8b1aeb672c0854b09bd6fcaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "929e454ff51c8f27eada30911b41ffd7d08b467873216a36d3225ca5aca5269d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    system bin/"skate", "set", "foo", "bar"
    assert_equal "bar", shell_output("#{bin}/skate get foo")
    assert_match "foo", shell_output("#{bin}/skate list")

    # test unicode
    system bin/"skate", "set", "猫咪", "喵"
    assert_equal "喵", shell_output("#{bin}/skate get 猫咪")

    assert_match version.to_s, shell_output("#{bin}/skate --version")
  end
end
