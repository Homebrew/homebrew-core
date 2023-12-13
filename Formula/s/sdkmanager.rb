class Sdkmanager < Formula
  include Language::Python::Virtualenv

  desc "Drop-in replacement for Android's sdkmanager that verifies all downloads"
  homepage "https://gitlab.com/fdroid/sdkmanager/"
  url "https://files.pythonhosted.org/packages/d1/f7/380ca52c2a11323008e267eb62c5f6d7d4224941bd83aa03db75ee689ca7/sdkmanager-0.6.5.tar.gz"
  sha256 "dd29505e449a99f1e4c6881c2d0488e3d88252da7ec7b1b0c6cb0e59853d5a85"
  license "AGPL-3.0-or-later"

  depends_on "python-argcomplete"
  depends_on "python-certifi"
  depends_on "python@3.12"

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  def python3
    "python3.12"
  end

  def install
    virtualenv_install_with_resources
    bash_completion.install "completion/bash-completion" => "sdkmanager"
  end

  test do
    assert_match "platforms;android-34", shell_output("#{bin}/sdkmanager --list")
  end
end
