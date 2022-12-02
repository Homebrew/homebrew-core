class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.42.3.tar.gz"
  sha256 "fbc08ebc81de8fdf43bb083d19c47867f8b4868294e3791fa9927a840ecf75d3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e4c0393bf20da12890535a619d9465f342374a77dc09dd01894da64431790ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2171f0fc2c2915deddbda0574a8a1e67c79460a464437a8a2ddae20f57f59d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aad7fcfcceab907eae56050b3028a8600764ecfe836035043a14e283c9d7e25c"
    sha256 cellar: :any_skip_relocation, ventura:        "48831032835664d44a69208ece200b469616646067bc4012068d76720679ea4a"
    sha256 cellar: :any_skip_relocation, monterey:       "bf120c809403f22817186ddd0f57f70ef4a9075b50a233c68bbb838c540f49da"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e35a6bb10f38319a06b01e3a491e7daa1982adc0c70a9fafeff9b0c1daf7c27"
    sha256 cellar: :any_skip_relocation, catalina:       "ea9437a0082685ef0692a51ca9b2c557a666aea832c0d09b69d02e7d402dad8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "660f5710ad192e8994889039ca6b20fc0723626a536cc191def843df8baba24d"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
