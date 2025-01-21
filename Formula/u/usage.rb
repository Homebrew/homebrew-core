class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v2.0.3.tar.gz"
  sha256 "164090bddb729adf22172ab7731707507b6dd60f8f3c642a59c444778c28ee18"
  license "MIT"
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5623b28ef9bc1fe2b63f9f28ae2d3c18db9d635e78e00ffed614702c963e2143"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c6c2eeed5aed65fc4b6e23dd5462fc60c41bdf54e0e2548f4a9db18102e3909"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5bff820c33b1a2608a84613fc7271eb05abd31a2e8c1a5cdc888b97593402ca4"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad84cbeb29ede6c3ab70cbac7b3d64997e1bf97718b9ca55b509b4cb72f9a758"
    sha256 cellar: :any_skip_relocation, ventura:       "a9dedcd85ba4dd4db8c4aca223b958f9bdb540355b35b32ad2447eeca2d5c574"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e6b586063ebc6c060c8b5f0bdb1014d5865883ba8624d3687786bdd3b6f43a6"
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
