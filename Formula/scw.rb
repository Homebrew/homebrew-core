class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v2.3.0.tar.gz"
  sha256 "2fccf3cd3c6d6fd94c4fd71bc8b20b14bb25534dc833594880d4a8edfb8ec139"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "84308c55a1ec66c17755835f455380ff170a64c11d8dd55f1d21311040d59c36"
    sha256 cellar: :any_skip_relocation, big_sur:       "8399d6e3b238847990e7def0479c510d1b2ebd26888acce38a4ae2fd550804f5"
    sha256 cellar: :any_skip_relocation, catalina:      "54baa872f088126ae8e2abf80cb69e3a239abac0e7dd20514d61d24c029a5693"
    sha256 cellar: :any_skip_relocation, mojave:        "9597e867e6732d017a2def430c5e6081705f6b58ea43981a46e95db331a9b061"
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
