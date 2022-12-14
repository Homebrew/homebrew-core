class Tut < Formula
  desc "TUI for Mastodon with vim inspired keys"
  homepage "https://tut.anv.nu"
  url "https://github.com/RasmusLindroth/tut/archive/refs/tags/1.0.25.tar.gz"
  sha256 "df1b4532a31fd90213c666dc508f6299a8785fe99e32317e86af739c76724b0f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34d436edac4b3e1f54388b9accae1b1dce3ae803cbe8b8b103601a5b9200c220"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1635fbbb83c6344a76fef76fe587674e53e56b3dfa77062d3244a0f022013bca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9b49c6e89372d47d4eefc5537b0264e323dee0f9570da0cf28d5426502d4f7a9"
    sha256 cellar: :any_skip_relocation, ventura:        "a3101a83af5f3b136e46aadc644a231fc63e8f24913a2db52a530ff223cb33ae"
    sha256 cellar: :any_skip_relocation, monterey:       "a2f10e73a930741029deb06bccaf572cd2406a69f095367e68906eec6e3c48e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "952091bd14a3fc3a2d9b701052088db72ffb0b9f131bde0fc6bba74a33634b12"
    sha256 cellar: :any_skip_relocation, catalina:       "19aa23ea134ea815c99179d3ff4328c0a62bf052b5ee959fe4399baf9b464fa3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d4de69d81372a976080c5fcf91cdf18dacd3527ba94a68fcc0c6c4f0c7555e6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tut --version")
    assert_match "Instance:", pipe_output("#{bin}/tut --new-user 2> /dev/null")
  end
end
