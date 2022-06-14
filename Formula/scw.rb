class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v2.5.2.tar.gz"
  sha256 "46d81343de0c059b40061480144820d9bdbdcc878f685558144661608c2ba5a0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e265c2cac190b3d1041dcbf19aa1f0ac64da14b208351fcebb45037350d0cf7b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c4ec946887cdf6a8c692d33091fe3dcdc603a16a2c268fdcf2277f409fc2998d"
    sha256 cellar: :any_skip_relocation, monterey:       "1a0e2706b232b9dae030893cee9ed006546393ef2b74114af6045471fdc515ef"
    sha256 cellar: :any_skip_relocation, big_sur:        "09e658570291d1fa7d574c8c403b6f2edf38c61c4a5d15adba9e507750c82d07"
    sha256 cellar: :any_skip_relocation, catalina:       "e3822af4cbea1b180f5657b81d51490931e97b52a848cec828bd8c07f8920b74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb7841c186c4a1d1a9df0dd7571be37490e2bc83944f9c31e70963afba6d6d4f"
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
