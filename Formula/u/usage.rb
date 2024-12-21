class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v1.7.4.tar.gz"
  sha256 "a768c0aef980ebc83bf93f763372c23de6c3aad03a925f981209dbc24ad59072"
  license "MIT"
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91ad8572f70a083c9bfcdfb790264f75cba5146f31da261876dfc62567143121"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92af4dbc2c4acd7122b6acd482d8777278544bf4f3f890d3d3bf7b221787e09b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e9a3b2bfafb953a58c0b119739530af1be455e796c6785b004865b2ef98f00ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9231bac7da5b662e14050bcc5b0cf2839b026563043d0874ce2c29479ce58a1"
    sha256 cellar: :any_skip_relocation, ventura:       "8aeab7defa155ee1ea0022b4c15b4187c8c86737ba56cd9cc54ad8033211681c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c31dde926f4a185aaede0a3fc326a6808a92cea2e8fabb183cd0d9505a5e5a7"
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
