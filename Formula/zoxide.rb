class Zoxide < Formula
  desc "Shell extension to navigate your filesystem faster"
  homepage "https://github.com/ajeetdsouza/zoxide"
  url "https://github.com/ajeetdsouza/zoxide/archive/v0.7.0.tar.gz"
  sha256 "9a9b0aa82a647fa834e4ade483af292e50080758af25c5260c425420879d9691"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "94a7c10678903d9dfb66e0fbf8c03811258b07062891ab843c1bb5ac9b437f87"
    sha256 cellar: :any_skip_relocation, big_sur:       "b64a6b6760c28a3bf15cd9db2119968bc4639a59355529ec7650f0ba216eaac4"
    sha256 cellar: :any_skip_relocation, catalina:      "3281359d883d9490faac2c11c7da5810101588fa2297ad0d838a75f259742cf9"
    sha256 cellar: :any_skip_relocation, mojave:        "88641c7715f8c1c7fc67cef24fb69a5976fe77917c5f724d430c505c43ef67dc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal "", shell_output("#{bin}/zoxide add /").strip
    assert_equal "/", shell_output("#{bin}/zoxide query").strip
  end
end
