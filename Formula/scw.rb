class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v2.4.0.tar.gz"
  sha256 "7baa6d7af5602703bc9b1f54beb5a36642151cc12d6584d6ab76df8bb088365e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3829e317a00f4ea4469786540f87060d78a7d21361f8ee0ab19a1179acfe3cb5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea477846761608cd68dfcfdd772307a64860454ed8355424b5296578a2cae620"
    sha256 cellar: :any_skip_relocation, monterey:       "01e2c3d0e432f725390ab705dc7087fa3417111fa0e0231f0f77bd96bbcea7d7"
    sha256 cellar: :any_skip_relocation, big_sur:        "c899cb2a69631bb599a9c184e985eaa6e7bf1e96f8e6ead790d946e61219dad4"
    sha256 cellar: :any_skip_relocation, catalina:       "c33c2946cab234e2bc4eac403a5be46ed912066adf33cb22e02c14f30809c69f"
    sha256 cellar: :any_skip_relocation, mojave:         "0d8bdd1f67799d9fa7b895836b6d5a08f0e8cf18dcc7b3114f7ab710060608c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12d71732f70e9b76ee3a8c57726610663e133d0293719a334b8016ec6326b206"
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
