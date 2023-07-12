class Theharvester < Formula
  include Language::Python::Virtualenv

  desc "Gather materials from public sources (for pen testers)"
  homepage "http://www.edge-security.com/theharvester.php"
  url "https://github.com/laramies/theHarvester/archive/4.3.0.tar.gz"
  sha256 "489037b539b7c25be54fc0d81235425dfe71e6c6dae41735f4470ba37b34cea9"
  license "GPL-2.0-only"
  revision 2
  head "https://github.com/laramies/theHarvester.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a0e2046e8a9254ca8c7116bc8f22a78f7ff96cf6faef24d49df353d9878c25e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89722b5f522614a2bf17b8b408d11b5be67bf9feca891f5b9ade4e260bebe865"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e5d9bb2eb9a8c9d5fd5b3105a4b6da2a168a03946c3a0821f2b8b8dce1f3c17d"
    sha256 cellar: :any_skip_relocation, ventura:        "080bb7fee9dfaa5f929767b9eb2951b4856aca7a39f25c1012a93590cfe57dfa"
    sha256 cellar: :any_skip_relocation, monterey:       "25ea8e749c67bdbc31cdc2ea88ada0d7b1d2d8f669b04865a1b73adeb78e04de"
    sha256 cellar: :any_skip_relocation, big_sur:        "247b034b4e54bba4c3fd0bfb980f85e092adc22479ecb3e3f2e442e41604e5fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "623a47ea88133436987d71fc41c0c11ca7ee26e1c06f3a38338ba0de7f7c1fca"
  end

  depends_on "cffi"
  depends_on "pycparser"
  depends_on "pygments"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  # How to update the resources
  # tar -zxvf theHarvester-#{version}.tar.gz
  # cd theHarvester-#{version} && virtualenv -p python3.11 .
  # source usr/local/bin/activate && pip install -r requirements/base.txt
  # pip freeze > dependencies.log
  # run homebrew-pypi-poet on the freezed dependencies
  def install
    inreplace "setup.py", "/etc/theHarvester", etc/"theharvester"
    venv = virtualenv_create(libexec, "python3.11")
    venv.pip_install resources

    bin_before = (libexec/"bin").children.to_set
    system libexec/"bin/python", *Language::Python.setup_install_args(libexec, libexec/"bin/python")
    bin_after = (libexec/"bin").children.to_set
    bin.install_symlink (bin_after - bin_before).to_a
    bin.install_symlink libexec/"bin/theHarvester" => "theharvester"
  end

  test do
    (testpath/"proxies.yaml").write <<~EOS
      http:
      - ip:port
    EOS

    output = shell_output("#{bin}/theharvester -d brew.sh --limit 1 --source urlscan 2>&1")
    assert_match "docs.brew.sh", output
    assert_match "formulae.brew.sh", output
  end
end
