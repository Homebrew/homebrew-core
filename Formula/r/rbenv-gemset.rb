class RbenvGemset < Formula
  desc "Adds basic gemset support to rbenv"
  homepage "https://github.com/jf/rbenv-gemset"
  url "https://github.com/jf/rbenv-gemset/archive/refs/tags/v0.5.10.tar.gz"
  sha256 "91b9e6f0cced09a40df5817277c35c654d39feaea4318cc63a5962689b649c94"
  license :public_domain
  head "https://github.com/jf/rbenv-gemset.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f4b32914a93a0af5a444ff4ace90678f07969a6e0e3aa5d63d0af655e3e570f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f3a6b6c538ac4b69ed5322a2d056b782ee42a40260359c71465c7817ee87d71a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd878825e721949e665c84452d74ec2c36c1b04a2da825ffb7dec3301d663fea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd878825e721949e665c84452d74ec2c36c1b04a2da825ffb7dec3301d663fea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd878825e721949e665c84452d74ec2c36c1b04a2da825ffb7dec3301d663fea"
    sha256 cellar: :any_skip_relocation, sonoma:         "149f261118f3e0abd75830b85ec456cb3a24edec190b97ea4e6c7083a7904e41"
    sha256 cellar: :any_skip_relocation, ventura:        "7db514b2352ec2cd623ebf7efe1feebb8125960531fbeda72e7a4e37cfe576f6"
    sha256 cellar: :any_skip_relocation, monterey:       "7db514b2352ec2cd623ebf7efe1feebb8125960531fbeda72e7a4e37cfe576f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "7db514b2352ec2cd623ebf7efe1feebb8125960531fbeda72e7a4e37cfe576f6"
    sha256 cellar: :any_skip_relocation, catalina:       "7db514b2352ec2cd623ebf7efe1feebb8125960531fbeda72e7a4e37cfe576f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "8a35b02c901c91d1e7c94b6aaecce7f143d1164f35f5fec234e55e69b4aef0ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd878825e721949e665c84452d74ec2c36c1b04a2da825ffb7dec3301d663fea"
  end

  depends_on "rbenv"

  def install
    prefix.install Dir["*"]
  end

  test do
    assert_match "gemset.bash", shell_output("rbenv hooks exec")
  end
end
