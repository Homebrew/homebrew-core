class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v2.2.3.tar.gz"
  sha256 "769920b3a2f94cd2ac260c0e1bc25639af17776383e6d1cb60cc870af9576d58"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "b410dd52d238835670a831130875fcc2e4307851ebac10fd5a4443bcdc8b016e" => :big_sur
    sha256 "57f7099f827810ef25f7956194c59d6504b98e209be37003fc4be2b647ec40f7" => :catalina
    sha256 "e0b5d4629a0efb6c8e40c9fd4260987c5c9caf35ebadbd6be827340588ea5087" => :mojave
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
