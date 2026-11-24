class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/46/f0/df58a3fc9bd0cae8b3a2b1ddd16aa0c7d47be73acd5318a00e85d924783c/tmuxp-1.81.0.tar.gz"
  sha256 "70f8d0d567790903acb64967ba9caaeffccd6ebb2fd047a6028f4ef0aaa22ffa"
  license "MIT"

  bottle do
    manifest_sha256 "559b9f9cdd768615418b123a1ed43fad4bb00082ff484aac97c21b4d23c0dbed"
    sha256 cellar: :any, arm64_golden_gate: "f11875a5cbcc043c13e2eaf3604356e86c304cd511e880be9a3be42dd218c34d"
    sha256 cellar: :any, arm64_tahoe:       "ebd417c88777fbe25d686a8f811faa928f8949e43162ab4a73cd370bf22aeeef"
    sha256 cellar: :any, arm64_sequoia:     "c1f5eb37310f68be497272b8c19a0e46e3bb5293e02c135d0547f84c3e37ff02"
    sha256 cellar: :any, arm64_linux:       "18dbf149d533a93c947574fff523fdc9f3dc4efe4897ae9b83bf78ac6af2f9a7"
    sha256 cellar: :any, x86_64_linux:      "987f8054158eedd170332b6246134dcb84cfd8ad93acb2c950c231b69b6319c3"
  end

  depends_on "libyaml"
  depends_on "python@3.15"
  depends_on "tmux"

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/72/f3/d33065929a6fe8c1005f34ebd8efc07be6fce4f068adfa3569005668b205/libtmux-0.67.1.tar.gz"
    sha256 "4de44cc40e35aed07cdf75f6f8d4062efa16731234ce8e2658d2f3b8edc20341"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/76/b8/c0b780928e2fb1c87e9e375818c6f121da2398b071012d1747be300b83f4/pyyaml-6.0.4.tar.gz"
    sha256 "e24bf71af8a432d7808fabff134d38dfe16d3cbb41f2873bb4b1e42422de0a1a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tmuxp --version")

    (testpath/"test_session.yaml").write <<~YAML
      session_name: 2-pane-vertical
      windows:
      - window_name: my test window
        panes:
          - echo hello
          - echo hello
    YAML

    system bin/"tmuxp", "debug-info"
    system bin/"tmuxp", "convert", "--yes", "test_session.yaml"
    assert_path_exists testpath/"test_session.json"
  end
end
