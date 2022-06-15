class Scalingo < Formula
  desc "CLI for working with Scalingo's PaaS"
  homepage "https://doc.scalingo.com/cli"
  url "https://github.com/Scalingo/cli/archive/1.23.0.tar.gz"
  sha256 "382e0272296595f0327146cb37c5b991c5e3387e26d0f0a4a01b9ab6df76befe"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc4fc82df67e3e442bdcb90861a2b065f39a900fb604cc78692ff90964eb9be6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de67f307a7f6dd0106fd291d936874c6efd1b125543fa76ec8c19dc50d0ccfe4"
    sha256 cellar: :any_skip_relocation, monterey:       "bf5399dd1ba25e9784741e736d92f301d60918ea63e28d16041db7ac3e9e31a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "8590b1c689749bc6f962ea7e3708bfc2311f4168a89472564f91b1ebacde3d7b"
    sha256 cellar: :any_skip_relocation, catalina:       "ff3101e6f0f5daf0e8aa17d75b602841cd0d152e629aeca427bced870e550486"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24bfd1a8adfcb4b9e01c5df9ff354b4057d79902231cc714e01ac3d5f35a6d74"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "scalingo/main.go"
  end

  test do
    expected = <<~END
      +-------------------+-------+
      | CONFIGURATION KEY | VALUE |
      +-------------------+-------+
      | region            |       |
      +-------------------+-------+
    END
    assert_equal expected, shell_output("#{bin}/scalingo config")
  end
end
