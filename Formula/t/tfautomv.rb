class Tfautomv < Formula
  desc "Generate Terraform moved blocks automatically for painless refactoring"
  homepage "https://tfautomv.dev/"
  url "https://github.com/busser/tfautomv/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "d89e19c03c7cd1ea1714d091cea751289936b2d52e790fae3a26b23bc445313d"
  license "Apache-2.0"
  head "https://github.com/busser/tfautomv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a9f6d13a8c6a71575153fa486dfcd6ed49eaf824d5d52fb1c3e3cfb8bbdcc22a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f2008e44b8a87c112dedaaaf588ae85d7924c6ae516b990930e3aaa496561681"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7a44d21ae1093c71a98213fd7bc9ee7d3580ef3a892dd6ef4dab6661063c598"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "916ac0746672c339e18cce67240025c827502721985de1370e8b92210b6d8bf2"
    sha256 cellar: :any_skip_relocation, sonoma:         "3c05cf7c115225365f5581be0ea2b83ac903d178b371f2b5bf3c5e905f5b2afa"
    sha256 cellar: :any_skip_relocation, ventura:        "5dc891bcc1497098c3682f6bc4ecb40c872bb70eafb048118161feed0fa3846d"
    sha256 cellar: :any_skip_relocation, monterey:       "dc9001cde510f52eefd365d491f494f525b589680c3cc2a6b2fcd396cb6683b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2413e0780e7e9601a1b62263d3fff816f1a10b2b0df145b5fdbb85c0641fa1a"
  end

  depends_on "go" => :build
  depends_on "opentofu" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    tofu = Formula["opentofu"].opt_bin/"tofu"
    output = shell_output("#{bin}/tfautomv --terraform-bin #{tofu} 2>&1", 1)
    assert_match "No configuration files", output

    assert_match version.to_s, shell_output("#{bin}/tfautomv --version")
  end
end
