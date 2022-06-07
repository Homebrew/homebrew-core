class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v2.5.1.tar.gz"
  sha256 "af926168122c192b10a19d701f2a03a41f14897b2a6c654499203edd2aafcafe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5e0ac68f17ccae80eaedb97c664036e83a3895de6c6270e170c7d3334ad99d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ffdeaa85b9fcfaf5bcb6c64d396fc0d3f7ef7fd32c0022386f6cabf4c0e41288"
    sha256 cellar: :any_skip_relocation, monterey:       "0987c424fd44bf9db4e4f1216afe91d5feada2163bd65326c8bd1cbdafa98e96"
    sha256 cellar: :any_skip_relocation, big_sur:        "b899a77c674e34c350ca9f87c3afc8bd91b146eb5ddf9e99af27ae49e082d8c4"
    sha256 cellar: :any_skip_relocation, catalina:       "36bfb953aff18e6fc48f2f43c00b805ee21339a04508b8829b9e5661afba6a46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2417dd45ec659a6b2005e1bff6c6f85cf24d4c5ed1ca9e16d94d05d4e1b6df2"
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
