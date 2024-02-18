class TranslateToolkit < Formula
  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/32/40/2776a3356a0902cd3962031f0d4d6eae04c6f17ca1ded575435182094ceb/translate-toolkit-3.12.2.tar.gz"
  sha256 "acee42b816f7796809b9b4768693664f6bd19fb96eae3d8dfec0932fa8761706"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4554fca7cc3fc003796fa7744e0d14b184dfdf9e0854d24c4d01c7a01de9f211"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a44310bbc9553a8fd356ed1dc9ee356b0cc6a648e14b1086620bfd57772445bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "356c5298bc02276599af20b8c479485e30f7bd1308c09100499c7384f900f251"
    sha256 cellar: :any_skip_relocation, sonoma:         "f6c52dab54c8aaf38ce91a12d6a45675797d9816d59e4491a99f98ce8bed2cdf"
    sha256 cellar: :any_skip_relocation, ventura:        "c574e02b353a9053580442b2cdd8cf46c1f1526c0059e9c792109fb4e9cb05e3"
    sha256 cellar: :any_skip_relocation, monterey:       "ad920621b4ae445fe83f422116443b11530da56d85a24d5f681c5b09fdeb4517"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "010eb219237ed6d5693ef2b6abf9d26430a75b35787942a8ac4fb1d2180a8771"
  end

  depends_on "python-setuptools" => :build
  depends_on "python-lxml"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    test_file = testpath/"test.po"
    touch test_file
    assert_match "Processing file : #{test_file}", shell_output("#{bin}/pocount --no-color #{test_file}")

    assert_match version.to_s, shell_output("#{bin}/pretranslate --version")
    assert_match version.to_s, shell_output("#{bin}/podebug --version")
  end
end
