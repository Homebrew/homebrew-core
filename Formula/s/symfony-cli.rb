class SymfonyCli < Formula
  desc "Build, run, and manage Symfony applications"
  homepage "https://github.com/symfony-cli/symfony-cli"
  url "https://github.com/symfony-cli/symfony-cli/archive/refs/tags/v5.17.1.tar.gz"
  sha256 "879782e8b8c6d6263e4d2a72f2283879f1c645c5f87db5cdd8a4bd8182e2ee37"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7b85716efe3c8176c084b717f0fd191ba216a5788cdd32012eaff976790ee7b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc975b34c6b9e42bf7550cee20976b94dc33788b85205d4c944878a27705d6b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "141ed733c1c0388af03cffc26e1cb4d66e63d1953f7ff94fcdefb27036587e4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa62a4550a52785a8503126ce21b32859faecc5279092c098000a96e6230795d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ccbc01de83b5163a30095e43ff76a2ef2408255b3eeb13203b372e8daca4fc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a67fc8eef94c1f0fdfd0bc950190a8a72f6d63961a096663afe222e44008416"
  end

  depends_on "go" => :build
  depends_on "composer" => :test

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.buildDate=#{time.iso8601}
      -X main.channel=stable
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"symfony")

    generate_completions_from_executable(bin/"symfony", "self:completion")
  end

  service do
    run ["#{opt_bin}/symfony", "local:proxy:start", "--foreground"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/symfony self:version")

    system bin/"symfony", "new", "--no-git", testpath/"my_project"
    assert_path_exists testpath/"my_project/symfony.lock"
  end
end
