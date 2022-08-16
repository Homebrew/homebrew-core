class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v2.5.5.tar.gz"
  sha256 "a5b201a31d22ed381e809d7f144d98189943b59f5b43e863a213a0a95eb439d7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ee56590768f19b6088b8f60fd8efa173bb9331538f2e0a4aac6db2f92ca2936"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47894e34bfe26b998abbaf25c0eb8b9eea17e8e767135ae8f27d06ea71513c08"
    sha256 cellar: :any_skip_relocation, monterey:       "7d257487fd04073fe44950776f1e9b0a0cc4467effe799c2ab489cc67735edc8"
    sha256 cellar: :any_skip_relocation, big_sur:        "7cf8e2688e9f798c00542c8e4ebefd7511f46459905300845e92e59dd107dfc6"
    sha256 cellar: :any_skip_relocation, catalina:       "0146f180893e8d49e15c15ea585a438d15d58abfa8dd1894562398b25277b1ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2f0e8cbbf7fb60910580eae9b020f68b8b4b80ef04f6e6de167f14e73f47b92"
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
