class Tuc < Formula
  desc "Text manipulation and cutting tool"
  homepage "https://github.com/riquito/tuc"
  url "https://github.com/riquito/tuc/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "e8208e0cb92bd17b36e1d43f0ea9d45f4573222fa40ca576775b4ebbb6442adf"
  license "GPL-3.0-or-later"
  head "https://github.com/riquito/tuc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c35d0097152baf416b76d4a86777d0ab9b48f9da0046c1a800874b3618adc03d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "537ca7a98e77de6b5f4cfc1958fad85057ccda999304de0671d789a2ca169aa3"
    sha256 cellar: :any_skip_relocation, monterey:       "56e293f4f47c68952f0e8c2fa7e627cfc32b38f1ea86f04f2422644aad972326"
    sha256 cellar: :any_skip_relocation, big_sur:        "6fa9c63920893eda18123703506c11fe389c5223bb87d4ce86f921e8da30acd8"
    sha256 cellar: :any_skip_relocation, catalina:       "c0bfaa86f7ff202b485e5eda4e391af965a18780bfd2876c80fa9426e3eab9c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26cf29e247aa014c052ecbd9e9a40a210a455c32ee97ba6ec6326da29c4be3c8"
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
