class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v2.5.3.tar.gz"
  sha256 "cf4ce3616d61fc5c1762663d660af9e06d59a15af3a2ce164b7f4c1c5b8aed3a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f005fc27d86815fdf450769690d8b7e5e4a1e778bf56bdb2e0896fd054f6bef0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0f4cd8e6f7198ee5bf58d7f8f9401844ea580bdde32c211a8c796b5d0855c958"
    sha256 cellar: :any_skip_relocation, monterey:       "0b0f07f1ef63bc2dab63f67523c1b6b1cf932c6011ed1f7bda7eec0074fec0e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b7a63286bd403579280a5ae046389f61362fab041a9829599425c3250fd0e26"
    sha256 cellar: :any_skip_relocation, catalina:       "c27707a61f2d8a2d21960eb6ca9faae2c795f9333aa52544a318aa948dbf1c84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab5bc870909dd1562c33c84667155c635127db771344a104a45f87b19fab856e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}"), "./cmd/scw"

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
