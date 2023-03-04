class Xcodes < Formula
  desc "Best command-line tool to install and switch between multiple versions of Xcode"
  homepage "https://github.com/RobotsAndPencils/xcodes#readme"
  url "https://github.com/RobotsAndPencils/xcodes/archive/refs/tags/1.3.0.tar.gz"
  sha256 "0173718a67b07304300798d9fb90729617acfffa757840a55289e5241c621f07"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e1392fa4b7eda1597523fc50a848108f1417682b6c87bcf2331eb3e065b6801"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6ce9c2019f07f0a0a1dc73b626e04bd571d2d882323528b9d19e8b8e841443d"
    sha256 cellar: :any_skip_relocation, ventura:        "71a947353cf60e60c0bf901ec57ae5b13cb651e4b70ac5ee7a89e8db7269aef6"
    sha256 cellar: :any_skip_relocation, monterey:       "1c65f7057e80b37aebb51e8e8d4e063bb5fe54b23f2d9bc0bdf9a4dd38999808"
  end

  depends_on xcode: ["13.3", :build]
  depends_on :macos
  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/xcodes"
  end

  test do
    assert_match "1.0", shell_output("#{bin}/xcodes list")
  end
end
