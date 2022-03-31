class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v2.5.0.tar.gz"
  sha256 "3b35b71554618e991f59a33fba6e9c6b32e95eeb05ac6ee82e7dd9108081a183"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aab6889425b7988dc4625408b8aff4745919f54e36639955ea0f229161b10d4d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "329526d63baa9f2bf9bf0ed6196ffab482af98c4f698ff51a8ff94b8e90589a8"
    sha256 cellar: :any_skip_relocation, monterey:       "8e2ebcf8cf1972283e4b3495f45ee5d5e221c64c5dbb885794a7843bcc71614a"
    sha256 cellar: :any_skip_relocation, big_sur:        "6632940d906d29f0e3c693e618d2c5c1a6972f15dbcfd35e1145b5543dde3658"
    sha256 cellar: :any_skip_relocation, catalina:       "bc04b5b0dc0721749caa804bbe2581cdceadf4a590a83a57fc9b57b9b7399938"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d950e6358f787d7927eb47d1296de6388ebb877f2fb13e421beb80c2658c9fc4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/scw"

    zsh_output = Utils.safe_popen_read({ "SHELL" => "zsh" }, bin/"scw", "autocomplete", "script")
    (zsh_completion/"_scw").write zsh_output

    bash_output = Utils.safe_popen_read({ "SHELL" => "bash" }, bin/"scw", "autocomplete", "script")
    (bash_completion/"scw").write bash_output

    fish_output = Utils.safe_popen_read({ "SHELL" => "fish" }, bin/"scw", "autocomplete", "script")
    (fish_completion/"scw.fish").write fish_output
  end

  test do
    (testpath/"config.yaml").write ""
    output = shell_output(bin/"scw -c config.yaml config set access-key=SCWXXXXXXXXXXXXXXXXX")
    assert_match "✅ Successfully update config.", output
    assert_match "access_key: SCWXXXXXXXXXXXXXXXXX", File.read(testpath/"config.yaml")
  end
end
