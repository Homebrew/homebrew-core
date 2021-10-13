class Ranger < Formula
  include Language::Python::Shebang

  desc "File browser"
  homepage "https://ranger.github.io"
  url "https://ranger.github.io/ranger-1.9.3.tar.gz"
  sha256 "ce088a04c91c25263a9675dc5c43514b7ec1b38c8ea43d9a9d00923ff6cdd251"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/ranger/ranger.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a02031ca657ef32cdf3560328dafafef9554d4268b94a8569055302e076341dd"
    sha256 cellar: :any_skip_relocation, big_sur:       "f54c357510b236077169fe474ca5e14ff038293bbd96c5823f7333da0da92bd1"
    sha256 cellar: :any_skip_relocation, catalina:      "f54c357510b236077169fe474ca5e14ff038293bbd96c5823f7333da0da92bd1"
    sha256 cellar: :any_skip_relocation, mojave:        "f54c357510b236077169fe474ca5e14ff038293bbd96c5823f7333da0da92bd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a02031ca657ef32cdf3560328dafafef9554d4268b94a8569055302e076341dd"
  end

  depends_on "python@3.10"

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
