class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v2.2.4.tar.gz"
  sha256 "e4b3a8b2cb682684bfa0c6c63d8074bb269867bc5910201c81bb10eef160a0d3"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "8088c820051babc7e934c5b6a3b4f4f3af5a8ca4861307fb81cb78e39c637c8c" => :big_sur
    sha256 "323d5a79e50e9fb954ff5a25232ddc85ae24b690322b3c2efdfb64971f027505" => :arm64_big_sur
    sha256 "34b8f4ad1a3cfd50e242f13ab53fee34085d7e1cb8b394384f378b928d10e21e" => :catalina
    sha256 "ec797ed2a4c6c8cd6d9b6b2a0a86827bdebe3c41997f85ab8f6ed28c73351ccd" => :mojave
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
