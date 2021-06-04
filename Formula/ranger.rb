class Ranger < Formula
  desc "File browser"
  homepage "https://ranger.github.io"
  url "https://ranger.github.io/ranger-1.9.3.tar.gz"
  sha256 "ce088a04c91c25263a9675dc5c43514b7ec1b38c8ea43d9a9d00923ff6cdd251"
  license "GPL-3.0-or-later"
  head "https://github.com/ranger/ranger.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "be8d7714ef29753d07b1b7ca166a674d13543a58b47883f9ed55895bc7e38f62"
    sha256 cellar: :any_skip_relocation, big_sur:       "89a02ad5b924aa4ea2ae75017ee5449ef5f5be633caaa84530608bc01b005d29"
    sha256 cellar: :any_skip_relocation, catalina:      "89a02ad5b924aa4ea2ae75017ee5449ef5f5be633caaa84530608bc01b005d29"
    sha256 cellar: :any_skip_relocation, mojave:        "89a02ad5b924aa4ea2ae75017ee5449ef5f5be633caaa84530608bc01b005d29"
  end

  depends_on "python@3.9"

  def install
    man1.install "doc/ranger.1"
    libexec.install "ranger.py", "ranger"
    bin.install_symlink libexec+"ranger.py" => "ranger"
    doc.install "examples"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ranger --version")
  end
end
