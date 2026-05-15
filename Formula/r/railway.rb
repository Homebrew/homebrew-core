class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v4.58.0.tar.gz"
  sha256 "a584c5f28af224b2bdfb42dbf18b9ced56d8c4047a2a2ef1be3c34824a308c65"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aec03b9922cf2b06207365fa90d452b497c2dff21ab1afe2fb9362672098faf8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aeb667a0e295b9a5c9817c84275b745a2b70ace1758e1bb1b9d6abf957314adc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee504edf27152df306303fc7fbce7aa1d9cfdd09bf37be28d01f84c225ae34be"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f3382411014349f35c0a99a9d5ceefb1589a06ee5cf3b522a7efb5050896f3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d64b785b81dc924724d34b90ca8e92249fc0c5cb356028817816665b190ab236"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5eaf61b97c333f553f677118f41832417b8e5f2644fec1c8ea5018d426358d6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railway #{version}", shell_output("#{bin}/railway --version").strip
  end
end
