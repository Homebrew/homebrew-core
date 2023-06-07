class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/traefik/yaegi"
  url "https://github.com/traefik/yaegi/archive/v0.15.1.tar.gz"
  sha256 "4f0894158f6331153522f48065db9c87237462e08c14652c84a65e3d28e6368b"
  license "Apache-2.0"
  head "https://github.com/traefik/yaegi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9e254b5ae147e0039257b152e26d141a7de35ec7dda8055ff499c8b361ee87e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9e254b5ae147e0039257b152e26d141a7de35ec7dda8055ff499c8b361ee87e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a9e254b5ae147e0039257b152e26d141a7de35ec7dda8055ff499c8b361ee87e"
    sha256 cellar: :any_skip_relocation, ventura:        "fa07402b69b8ac8433d5790857d44ed5d5ba3002c5eb2e854c8738670445db33"
    sha256 cellar: :any_skip_relocation, monterey:       "fa07402b69b8ac8433d5790857d44ed5d5ba3002c5eb2e854c8738670445db33"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa07402b69b8ac8433d5790857d44ed5d5ba3002c5eb2e854c8738670445db33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5657b3d88c8ce1d60aca7d7cf2ade108e2dda1d4ff1ab41a538d2dc2df7ccbd2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X=main.version=#{version}"), "./cmd/yaegi"
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "println(3 + 1)", 0)
  end
end
