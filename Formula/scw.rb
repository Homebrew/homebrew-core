class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v2.2.0.tar.gz"
  sha256 "2438fffd9d15f50a3cfb78deeaf7e2e9d7b9c7fb37187a6f442b30c04a536ff5"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "c11b7fc563ff4f88728f913865037eb60eb8fd9a6e4de2cd72967b3c6d32c4d2" => :catalina
    sha256 "9729fc288de05cfb1ad122619ab247a497e6d53f32202430ad5e47b25d015570" => :mojave
    sha256 "4dcbfe7942ee684dbc6c8779c7e424f7d6a25a3b0bfc1e4902a5d4f755a05ecb" => :high_sierra
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
