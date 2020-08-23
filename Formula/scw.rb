class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v2.0.0.tar.gz"
  sha256 "3f219c83e3766eb253791ac74c6bf92f8b2234e147cf5d268254cf5cc6ab7d03"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "fa19569accc1ca1932d378b8992d92006f9d316668b46648d1129d1189b9ec5c" => :catalina
    sha256 "a7314e226c796068b8e2c5d483ce0ff309f0fffbb82539a7e8070af57bef7580" => :mojave
    sha256 "12e03cb964ccde5f40f801479ab51ee89d512e539eda72e66352079d75c91768" => :high_sierra
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
