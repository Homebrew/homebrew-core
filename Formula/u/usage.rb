class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v2.0.4.tar.gz"
  sha256 "2e61ff37e3e4c1869760234263ae2fe9bfed6387f56b16574ef4436da125135b"
  license "MIT"
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58732822bcbaa10dbd9e1342f4607e00c2ab8f1d1781a35c7d9da015a3a14be0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6600a7756944fd10d8460a4378875222ff6732bb6bb8f43e50e5f31a977ac646"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7c35be85a3f2e375c735f4238db767fa60d85f6603e17134ff3611f90ce73c28"
    sha256 cellar: :any_skip_relocation, sonoma:        "e564cf2b754aa4f147d1f47297c32b2dade8d9ad5446a63e2be4a5668e506966"
    sha256 cellar: :any_skip_relocation, ventura:       "b05dd275f9b092a039ddc8f8f9f195f623148c4b8ec12976e212a286c3beffe1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9df40dc31d7e868079c07e0c3843bbe9c321964cdde9f0caedd67b8864a97939"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match "usage-cli", shell_output(bin/"usage --version").chomp
    assert_equal "--foo", shell_output(bin/"usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end
