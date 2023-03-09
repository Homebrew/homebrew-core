class Talisman < Formula
  desc "Tool to detect and prevent secrets from getting checked in"
  homepage "https://thoughtworks.github.io/talisman/"
  url "https://github.com/thoughtworks/talisman/archive/refs/tags/v1.30.2.tar.gz"
  sha256 "d1cd895f89187d879352a7093679424857cb8809969cbba6437744123e6f5cb3"
  license "MIT"
  version_scheme 1
  head "https://github.com/thoughtworks/talisman.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4af4f91a18c6948f43c7d5dfcb86898516f9e3f5668edabb21c9215154621b40"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a05eaa21c8abaa050135eae5c54dd5fd1baa90d0ff774583e7d70fe3efbb126f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "96d217a0da5368744829033915bddd2b2c0d334ef3ccd15ca597be9113c00181"
    sha256 cellar: :any_skip_relocation, ventura:        "70413d979d52dbd5fad2f11ad6b6fcd007e5016f142d450f6ab823174679d905"
    sha256 cellar: :any_skip_relocation, monterey:       "908b104981718c4815e6c6014a750d4e1c2c2920ee470a22d5ba828b92112675"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b97c81154b43e0b9b561dc31d017df6d0bf14d1e53c7470f2606830341e81d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad8e9511e94538dcd5b725eb5b32d17fd7991c5fc02baf9f1f439d4d21f1b5d9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}"), "./cmd"
  end

  test do
    system "git", "init", "."
    assert_match "talisman scan report", shell_output(bin/"talisman --scan")
  end
end
