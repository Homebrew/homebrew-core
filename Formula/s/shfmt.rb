class Shfmt < Formula
  desc "Autoformat shell script source code"
  homepage "https://github.com/mvdan/sh"
  url "https://github.com/mvdan/sh/archive/refs/tags/v3.11.0.tar.gz"
  sha256 "69aebb0dd4bf5e62842c186ad38b76f6ec2e781188cd71cea33cb4e729086e94"
  license "BSD-3-Clause"
  head "https://github.com/mvdan/sh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86443c9bdac7eb362c1f37111b65c5571ac9c1ff3af9cc400fa21339638df3d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86443c9bdac7eb362c1f37111b65c5571ac9c1ff3af9cc400fa21339638df3d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "86443c9bdac7eb362c1f37111b65c5571ac9c1ff3af9cc400fa21339638df3d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "30ebd6b438e9bb454607def57433c30bfecff1e409f9715e8c568393b4804001"
    sha256 cellar: :any_skip_relocation, ventura:       "30ebd6b438e9bb454607def57433c30bfecff1e409f9715e8c568393b4804001"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b809496358ce36789fc7bceed6f207228fae5a60e65c14d0bfb742ce50a52e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cf55cb5df6f5ba0b8bdbb9a734dbae95f110080b87909b2698f0ffa6d0d7912"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -extldflags=-static
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/shfmt"
    man1.mkpath
    system "scdoc < ./cmd/shfmt/shfmt.1.scd > #{man1}/shfmt.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shfmt --version")

    (testpath/"test").write "\t\techo foo"
    system bin/"shfmt", testpath/"test"
  end
end
