class Xeol < Formula
  desc "Xcanner for end-of-life software in container images, filesystems, and SBOMs"
  homepage "https://github.com/xeol-io/xeol"
  url "https://github.com/xeol-io/xeol/archive/refs/tags/v0.9.14.tar.gz"
  sha256 "60b1c20c8ac958602f9763d87114f5788a1a64067e5b7384ca48fa4d936a3820"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "52b110bea548a494edadbd41d9add0c80e2f4d2fa8e2d603019c9827b6bd9ed3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "918412fa235204787aa410e6f2e0bcb9390262ec91b5d38ad2c52b5aa1052c1d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37fe16f57df5c1a12e17fd2e6c053543715a720999bc5776d4969a4c6cc671b7"
    sha256 cellar: :any_skip_relocation, sonoma:         "ae1a8b18e2bdfa81c20b7c3470e612f61fc1839be38d9f904583362669451583"
    sha256 cellar: :any_skip_relocation, ventura:        "15d23926153c0b32e64572da1d1989760732565343a6c64914cb2c0e6802fbb5"
    sha256 cellar: :any_skip_relocation, monterey:       "1b2e30a100f6073401d6e7b940b66f94daf73766567b4b69d2f0bc3b1009487b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81b505cf764c9c518f7939fc15f5cb22d2d145d5d80badbf590b7712f274c9ff"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=#{tap.user}
      -X main.buildDate=#{time.iso8601}
      -X main.gitDescription=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/xeol"

    generate_completions_from_executable(bin/"xeol", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xeol version")

    output = shell_output("#{bin}/xeol alpine:latest")
    assert_match "no EOL software has been found", output
  end
end
