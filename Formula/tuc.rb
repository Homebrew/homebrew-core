class Tuc < Formula
  desc "Text manipulation and cutting tool"
  homepage "https://github.com/riquito/tuc"
  url "https://github.com/riquito/tuc/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "47848b23268c5d22efcc9f7f6a6da73f27483b336005c2ace350bff575e51d67"
  license "GPL-3.0-or-later"
  head "https://github.com/riquito/tuc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd5483e0ed21ce3ea3b18578c98c47543f4b741043a06f1a7e21885387d2e02c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "739f513a991ac172b5244dcd424390df770742e8919dc8508332f29cae3fc158"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5cc23018bf7a230eacc43c7ee04c8c6c8a33de6c515500472d1aed089e789b6e"
    sha256 cellar: :any_skip_relocation, ventura:        "e88c5ecb90e42a978f4ddceef9715495cb5380d2f65526a6d0d68fde04dcddf6"
    sha256 cellar: :any_skip_relocation, monterey:       "a3bfaaf6eceea2e2c489bc7893ab7a17c09281cea45c124ce3910827fba3e45c"
    sha256 cellar: :any_skip_relocation, big_sur:        "b5b110ad523193b0427466024fbcbf55ddef862278d42f87a3b75c053f1001f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e098b815ab092bf5cc10908a8ee769d5084f3eb40207ad498b7046cec2ba8b7c"
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
