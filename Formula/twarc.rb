class Twarc < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool and Python library for archiving Twitter JSON"
  homepage "https://github.com/DocNow/twarc"
  url "https://files.pythonhosted.org/packages/74/65/debf259d69eb2e0bba12c4d5ee68c102b690e338fda2eb4ae130d76dde92/twarc-1.8.4.tar.gz"
  sha256 "d4601930da4ec1f729667772b4539ef0507df171b470184775ada4b5598646b0"

  bottle do
    cellar :any_skip_relocation
    sha256 "979a3b34b473a7bb9ac6b2e5ac31e642af0e84b9d1b08ce2d91a77facf2817bb" => :catalina
    sha256 "669ae23bb0fb58e8c35ae3c3c6de561b26c52cbdb9bb58e43be0062bab72d6d3" => :mojave
    sha256 "4eea637c48689bb6246bed2894cd17049f817c409e15446ad3d2870afb66754a" => :high_sierra
  end

  depends_on "python@3.8"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "twarc"
    venv.pip_install_and_link buildpath
  end

  test do
    assert_equal "usage: twarc [-h] [--log LOG] [--consumer_key CONSUMER_KEY]",
                 shell_output("#{bin}/twarc -h").chomp.split("\n").first
  end
end
