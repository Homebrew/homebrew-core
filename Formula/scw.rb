class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v2.5.0.tar.gz"
  sha256 "3b35b71554618e991f59a33fba6e9c6b32e95eeb05ac6ee82e7dd9108081a183"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b482ed3c335bbb8cd66cdde9f73c31cd7021910bb63be1b4fb2173a875317c8a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c55e4bf7f4be0dbc8b4de8d71548169eca3149d064bc63524acd3d0577a294be"
    sha256 cellar: :any_skip_relocation, monterey:       "96d538ad56ba2683b276a3b4e2da08a72312e93da4beefd3e697a2526cab6e90"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ff147505711071639bad8101c291c03f99387a34c0955f077b1342c38c2891d"
    sha256 cellar: :any_skip_relocation, catalina:       "7d467a8da9288de43f55d22df4edf9fb7dccc005f633524080a510bfd9a12184"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a08df8e0f01bd8d79ef3d278b30204e44f1800145c94d7cfcb219fd0d5e3a9c"
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
