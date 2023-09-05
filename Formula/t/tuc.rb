class Tuc < Formula
  desc "Text manipulation and cutting tool"
  homepage "https://github.com/riquito/tuc"
  url "https://github.com/riquito/tuc/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "ea4d1adb1949b8f564c375cbd7e0569de5dcc1fcabd57d56174748091102eec2"
  license "GPL-3.0-or-later"
  head "https://github.com/riquito/tuc.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f578d51858fa5dda588b3a7517f7659be032593b1f160aacd4f792b251be03f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c38d7a077f7b23da3db1c4e8bf3269b16c5324a44ef3ae326f6640250717223a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "95e896f7d2562a0fb0339b1a5335cab57678c01bc7ad2176f23ff3e492eedf7d"
    sha256 cellar: :any_skip_relocation, ventura:        "1ec1cba84e3b510ce6e07369eeb85e933022d9fd894609b7d8eb50640a6b5748"
    sha256 cellar: :any_skip_relocation, monterey:       "983376b05c608b5c1cd0bdf95678b948c1f96c3d565298b0c584845a7f622e2d"
    sha256 cellar: :any_skip_relocation, big_sur:        "b1a0dc09cbb7cda41144e5d6e288bd238b6717a927015993c6a66b08b7a92919"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "334bfc02d97c2291a1b45d51d20afdc906e063b21baac1205e66c970adecb1b5"
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
