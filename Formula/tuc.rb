class Tuc < Formula
  desc "Text manipulation and cutting tool"
  homepage "https://github.com/riquito/tuc"
  url "https://github.com/riquito/tuc/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "e8208e0cb92bd17b36e1d43f0ea9d45f4573222fa40ca576775b4ebbb6442adf"
  license "GPL-3.0-or-later"
  head "https://github.com/riquito/tuc.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e7c00918141e32f21da94288bb29beae137f220517603c888962c19c670413b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51d443992c134b4a5448a764ce1b9eb972eacf711a06cdac386e64961e1425df"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "058081c832d1526d067cfdf43254106329a5d3c39093afaa73af9c4df1a69092"
    sha256 cellar: :any_skip_relocation, monterey:       "accd6c100cfe52050f9c67e208d44fb71a1e7aaf6da3f1d9619c5b30f4aaf06c"
    sha256 cellar: :any_skip_relocation, big_sur:        "1013a3c42ad1130863d651b67ae3b46d60effce216480619a817cf8648c1c105"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c5af51e908c788ea4ebf48d4487d520a4e61e94498b38b896f85cebd68010b6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "regex", *std_cargo_args
  end

  test do
    output = pipe_output("#{bin}/tuc -e '[, ]+' -f 1,3", "a,b, c")
    assert_equal "ac\n", output
  end
end
