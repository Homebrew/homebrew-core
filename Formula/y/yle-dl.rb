class YleDl < Formula
  desc "Download Yle videos from the command-line"
  homepage "https://aajanki.github.io/yle-dl/index-en.html"
  url "https://files.pythonhosted.org/packages/30/0b/9aa68156e76a4b32681bdb89bdd360120d6445f6d92e604c5a5e73f23066/yle_dl-20231214.tar.gz"
  sha256 "cc0591e2d4450c34f2f17c2069de1ab74669a735979f256b32501bf771ee8f32"
  license "GPL-3.0-or-later"
  head "https://github.com/aajanki/yle-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "31d5df8b2be107854c934b0fc78febd9d45d6f6f6eefd37a2a903f0dbba433b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79db770d7c4211866f92bc58721ad8ed33a29038f09933f468aaadcf97895c66"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab8507aa6c939f8134965e5b3dc9a75c8e8c3fb13b91459ecb5a98ec39ba0898"
    sha256 cellar: :any_skip_relocation, sonoma:         "12c2d24e69a4e5db745a89920f1438fd96f7431c76c3ad3edd3d73e5fb3a29a0"
    sha256 cellar: :any_skip_relocation, ventura:        "1a2b16e2442322471c335210a2b28ca5ac14711d14f58fa8fce5595e794025ff"
    sha256 cellar: :any_skip_relocation, monterey:       "226732048cd6f68fb8e6991b5fce534f90488caf65e1fdc75dff05d208645417"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff9e5c8398f293f4363a0a20bd146c3ed5bd32693d04095e311e0ef04724ef91"
  end

  depends_on "python-flit-core" => :build
  depends_on "cffi"
  depends_on "ffmpeg"
  depends_on "pycparser"
  depends_on "python-configargparse"
  depends_on "python-lxml"
  depends_on "python-requests"
  depends_on "python@3.12"
  depends_on "rtmpdump"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    output = shell_output("#{bin}/yle-dl --showtitle https://areena.yle.fi/1-1570236")
    assert_match "Traileri:", output
    assert_match "2012-05-30T10:51", output
  end
end
