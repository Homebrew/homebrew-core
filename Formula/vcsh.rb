class Vcsh < Formula
  desc "Config manager based on git"
  homepage "https://github.com/RichiH/vcsh"
  url "https://github.com/RichiH/vcsh/archive/refs/tags/v1.20190621-4.tar.gz"
  version "1.20190621"
  sha256 "178ddf6f7bba15bcc295a08247070665e5b799af64753e21c7fac68f72296ca8"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d6adf58cb690fa63602d8056d347bf55dde6ebd090c6f82d1bbbbc78b137d93b"
  end

  def install
    bin.install "vcsh"
    man1.install "vcsh.1"
    zsh_completion.install "_vcsh"
  end

  test do
    assert_match "Initialized empty", shell_output("#{bin}/vcsh init test").strip
  end
end
