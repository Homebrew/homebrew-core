class Scmpuff < Formula
  desc "Numeric file selection shortcuts for common git commands"
  homepage "https://github.com/mroth/scmpuff"
  url "https://github.com/mroth/scmpuff/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "dbff8913217f6ec0915671057933eacd692e7810bf64ded25bba63e98240b789"
  license "MIT"
  head "https://github.com/mroth/scmpuff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "905a460527378b663c6e4c81422eb0842a3b495e03990ac38466d14ae35387d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "905a460527378b663c6e4c81422eb0842a3b495e03990ac38466d14ae35387d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "905a460527378b663c6e4c81422eb0842a3b495e03990ac38466d14ae35387d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "a40113c4008e4411538f39e74c7098885f48db23def72f42523bc26a8313e86a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2c0f354dd043dda61d68a3794d73f85f32154bb3a5ac505d0f725d9b9db8876"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ae88dd75983370f296d6b715556d13dc39b937ec2e7beb653071aaf5883b7c5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.builtBy=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/scmpuff --version 2>&1")

    ENV["e1"] = "abc"
    assert_equal "abc", shell_output("#{bin}/scmpuff expand 1").strip
  end
end
