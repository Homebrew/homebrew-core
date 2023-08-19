class Xe < Formula
  desc "Simple xargs and apply replacement"
  homepage "https://github.com/leahneukirchen/xe"
  url "https://github.com/leahneukirchen/xe/archive/refs/tags/v1.0.tar.gz"
  sha256 "1e2484c6295f4eb1c1b789d8edab4b728cf9ea7e4c40ef52a56073f9a273ce30"
  license :public_domain
  head "https://github.com/leahneukirchen/xe.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02cf3b1d7b641be3ca3c2c468663a922b031e6348edef5e4a498cf3ccf578e10"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f15ffcac383f2223add8727e887be74af895b347cbecc4dc185745d21a86ed5d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a81ab4f43492a5ad82225d579046c114ede2140390395fc62241f7d0bcb50af"
    sha256 cellar: :any_skip_relocation, ventura:        "fa22ab803e09d78b5aca3d0b4c9773b3a1db1bcd4f5f254a39f1af6a2daf578b"
    sha256 cellar: :any_skip_relocation, monterey:       "fe9fe7ccd998c7030b507f8e382986b7a4c599fdcc7dad851f1dbca173317333"
    sha256 cellar: :any_skip_relocation, big_sur:        "f2eb0cdecdd23ec242f05977a913055d8170c8cf9d793641c7633f54599e52d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b67d52094aa34b8882194aa6fa429b13ed8866abbc33ae906d3f0253b52ff61"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"input").write "a\nb\nc\nd\n"
    assert_equal "b a\nd c\n", shell_output("#{bin}/xe -f #{testpath}/input -N2 -s 'echo $2 $1'")
  end
end
