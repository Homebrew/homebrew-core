class Rbw < Formula
  desc "Unoffical Bitwarden CLI client"
  homepage "https://github.com/doy/rbw"
  url "https://github.com/doy/rbw/archive/refs/tags/1.7.1.tar.gz"
  sha256 "8c8dc95dc0846c0c51f0b13c9e60a4b4e722c8befb932e8d06c462d70deaf096"
  license "MIT"
  head "https://github.com/doy/rbw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "edbe7e41b8ddc8642d7f98519a071993e53538c16eb22e2cb5467db445f9e503"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "891fd2a52bab9c5110375973fc1377911aa3f09b8ead1b3865fa4ba53cadf115"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0b0447d44f9c710f8647eccdb756bffae473da6c8c525811a1c5520585d940d"
    sha256 cellar: :any_skip_relocation, ventura:        "2ad37ebb6e19e92104cbf41ae9232ba2a21809b0453a876fa86163ba37063aa5"
    sha256 cellar: :any_skip_relocation, monterey:       "8e06e27ca6e673b66f15ac327040c825ff96664875a6745afb8a690c12a4c27f"
    sha256 cellar: :any_skip_relocation, big_sur:        "d3d65631d9bffbac66fbed1a617bb1f2543f132489a5dd13222511ab15ed0a86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f687a16d27e5375aa90289f94be9fd68bb866cac815bd43137eed34b5ac6cddb"
  end

  depends_on "rust" => :build
  depends_on "pinentry"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"rbw", "gen-completions")
  end

  test do
    expected = "ERROR: Before using rbw"
    output = shell_output("#{bin}/rbw ls 2>&1 > /dev/null", 1).each_line.first.strip
    assert_match expected, output
  end
end
