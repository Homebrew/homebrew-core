class Xurls < Formula
  desc "Extract urls from text"
  homepage "https://github.com/mvdan/xurls"
  url "https://github.com/mvdan/xurls/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "552779a765de29e51ff01fe6c85a7d0389faae1b80d354332e7c69db232ee4ad"
  license "BSD-3-Clause"
  head "https://github.com/mvdan/xurls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2e807c057433c0ed36d7143bd8996cf6e2f45d63b34fac89b2c8958928e3122f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e1bff20d5c71c28fd1931855730748b6b45accd8282d399fd2d854db05d98830"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c450839ae17f188495de308aba6e40980a624c456c0da546879685f527712529"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c450839ae17f188495de308aba6e40980a624c456c0da546879685f527712529"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c450839ae17f188495de308aba6e40980a624c456c0da546879685f527712529"
    sha256 cellar: :any_skip_relocation, sonoma:         "8df1a2861505f8499e8d8644c3c0a61bf1b32ef2acfb74e2a312cda35c7aa688"
    sha256 cellar: :any_skip_relocation, ventura:        "dc19854a4968ff35b25301605dee1a83e2efbc210a6b5029b3f1d28b93a8edb8"
    sha256 cellar: :any_skip_relocation, monterey:       "dc19854a4968ff35b25301605dee1a83e2efbc210a6b5029b3f1d28b93a8edb8"
    sha256 cellar: :any_skip_relocation, big_sur:        "dc19854a4968ff35b25301605dee1a83e2efbc210a6b5029b3f1d28b93a8edb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09b207fe83c1fbf801cc3270b27234ea6beac64e243ee1d0209292aa54723f1e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/xurls"
  end

  test do
    output = pipe_output(bin/"xurls", "Brew test with https://brew.sh.")
    assert_equal "https://brew.sh", output.chomp

    output = pipe_output("#{bin}/xurls --fix", "Brew test with http://brew.sh.")
    assert_equal "Brew test with https://brew.sh/.", output.chomp
  end
end
