class Wego < Formula
  desc "Weather app for the terminal"
  homepage "https://github.com/schachmat/wego"
  url "https://github.com/schachmat/wego/archive/2.2.tar.gz"
  sha256 "e7a6d40cb44f4408aedceebbed5854b3b992936cc762df6b76f5a9dca7909321"
  license "ISC"
  head "https://github.com/schachmat/wego.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f5b23391824baaec44fd2319999c09b6ffac91b2985889b1ea73a2974ad19ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f5b23391824baaec44fd2319999c09b6ffac91b2985889b1ea73a2974ad19ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f5b23391824baaec44fd2319999c09b6ffac91b2985889b1ea73a2974ad19ef"
    sha256 cellar: :any_skip_relocation, ventura:        "dc2004af7cbb8e2a43f2d498784920a7352828bf4a605a2a8035c8e5fa41787b"
    sha256 cellar: :any_skip_relocation, monterey:       "dc2004af7cbb8e2a43f2d498784920a7352828bf4a605a2a8035c8e5fa41787b"
    sha256 cellar: :any_skip_relocation, big_sur:        "dc2004af7cbb8e2a43f2d498784920a7352828bf4a605a2a8035c8e5fa41787b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c8b6f1f1a2f2234517e996ffda49f1ee0d4c6ed648c6d08de6ccdaa2df7ef7e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    ENV["WEGORC"] = testpath/".wegorc"
    assert_match(/No .*API key specified./, shell_output("#{bin}/wego 2>&1", 1))
  end
end
