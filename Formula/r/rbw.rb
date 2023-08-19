class Rbw < Formula
  desc "Unofficial Bitwarden CLI client"
  homepage "https://github.com/doy/rbw"
  url "https://github.com/doy/rbw/archive/refs/tags/1.8.3.tar.gz"
  sha256 "fc04572a7215f89de018621c003c38c0400befd02e16efe8a00677d88ebe3c35"
  license "MIT"
  head "https://github.com/doy/rbw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78fd9b44cb21072e127a576e5c9b63439db314aa3f728bc72962ff0d88cf6b37"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a94805df40043b4ca6ebd656fa56e6cf7ab5bc6b314ca3a10abc969c936e0941"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9553694afb068155c24633827e5d7723df11935e6b0d69c5de63212b69a7e37c"
    sha256 cellar: :any_skip_relocation, ventura:        "b6b87134a462a889b6935f5c59a262c4d624d0d076e0f6fcf25c467b13b415a8"
    sha256 cellar: :any_skip_relocation, monterey:       "c7439f1649f77598556647738ff2c366b65901b58a35b212507ce2d413fda90e"
    sha256 cellar: :any_skip_relocation, big_sur:        "d39d862eaee12f64a7c434ec43df2480816e8fa4fcd3ad6a50b1694798cf4ad9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d98962a383cb80cd37720ddb32cd66013a600cc3d2c1d066d8e0722355631ad"
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
