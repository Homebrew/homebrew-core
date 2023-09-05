class WoodpeckerCli < Formula
  desc "CLI client for the Woodpecker Continuous Integration server"
  homepage "https://woodpecker-ci.org/"
  url "https://github.com/woodpecker-ci/woodpecker/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "1c375d2a93f2e874811fa508008deeb92e4fa52b9249633f4916208dd2a63cee"
  license "Apache-2.0"
  head "https://github.com/woodpecker-ci/woodpecker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3dbef4469ff07bf08235af540f9886313b254e7c81d3cb7f33e8079471fa6f17"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5eb663cd78c98015256f11345d6d7b4ac26a514f4ff02ec761173e71faa258f6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb20824cc853f44437e1d6943bc4f42ce041c3864e3456ee628fb23dc954edcb"
    sha256 cellar: :any_skip_relocation, ventura:        "090691d8329d5d0439b8c0d631000fb0513bad1b3eb76201394413f8b9a4ed5c"
    sha256 cellar: :any_skip_relocation, monterey:       "aa62cb28f0b0f849ed01729b55919209ec4d51f682f30e5a37ead85ee7e2d2de"
    sha256 cellar: :any_skip_relocation, big_sur:        "70c1a26388624586855eefed357162c41e9887cfe0628c1792774084521e3c04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d63ac231ffe2297cc218ea401d402b4a44be6433cdd6585fda61423683e5456"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/woodpecker-ci/woodpecker/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/cli"
  end

  test do
    output = shell_output("#{bin}/woodpecker-cli info 2>&1", 1)
    assert_match "Error: you must provide the Woodpecker server address", output

    output = shell_output("#{bin}/woodpecker-cli lint 2>&1", 1)
    assert_match "could not detect pipeline config", output

    assert_match version.to_s, shell_output("#{bin}/woodpecker-cli --version")
  end
end
