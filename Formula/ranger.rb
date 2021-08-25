class Ranger < Formula
  include Language::Python::Shebang

  desc "File browser"
  homepage "https://ranger.github.io"
  url "https://ranger.github.io/ranger-1.9.3.tar.gz"
  sha256 "ce088a04c91c25263a9675dc5c43514b7ec1b38c8ea43d9a9d00923ff6cdd251"
  license "GPL-3.0-or-later"
  head "https://github.com/ranger/ranger.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9757fe41fe8386ec511d183afa2262b88d2c6eae261c422f309fb2096492d5d3"
    sha256 cellar: :any_skip_relocation, big_sur:       "06cd4e35309bd7089184d39db275a1a7b798503312987d18068c1fa729372aa1"
    sha256 cellar: :any_skip_relocation, catalina:      "06cd4e35309bd7089184d39db275a1a7b798503312987d18068c1fa729372aa1"
    sha256 cellar: :any_skip_relocation, mojave:        "06cd4e35309bd7089184d39db275a1a7b798503312987d18068c1fa729372aa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9757fe41fe8386ec511d183afa2262b88d2c6eae261c422f309fb2096492d5d3"
  end

  depends_on "python@3.9"

  def install
    man1.install "doc/ranger.1"
    libexec.install "ranger.py", "ranger"
    rewrite_shebang detected_python_shebang, libexec/"ranger.py"
    bin.install_symlink libexec/"ranger.py" => "ranger"
    doc.install "examples"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ranger --version")
  end
end
