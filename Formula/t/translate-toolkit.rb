class TranslateToolkit < Formula
  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/78/03/246848a23799a5a7b1b4e5a242ee923b45cec4da64ef34677d8799fcae55/translate-toolkit-3.12.1.tar.gz"
  sha256 "69e4c68f0e60a259b6176aa173bfeb0de6eba1c2adbfb0aa95a279ba4be26525"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7e09d1199d511d39bdd95047434ae1e2f1969929dbb104504ba06aadfb7f69a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a1148519fdba2438a254ffbc87a0a19458337a6892dacfb773bc29e350c3aacd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26274da3a650bf42d873ba92789febf1bd3b9813f9771cbe49946f4d702bf422"
    sha256 cellar: :any_skip_relocation, sonoma:         "a71b9e6bb837faa200cfe38588336349e214b6d68e973f51f21822a571fd0910"
    sha256 cellar: :any_skip_relocation, ventura:        "1029718e4c72c077294dc157870433061c667a4d87f94529291a1281ac38333b"
    sha256 cellar: :any_skip_relocation, monterey:       "9c64ad91042857eb79b25d974151a37d71e037e619181bd99808326e60bb8179"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "087fb8bbf28b4046e59373fd82dfc91d085f7c86d27c3e1de50075fe7c68ca73"
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
