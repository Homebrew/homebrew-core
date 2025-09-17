class Yamdi < Formula
  desc "Add metadata to Flash video"
  homepage "https://yamdi.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/yamdi/yamdi/1.9/yamdi-1.9.tar.gz"
  sha256 "4a6630f27f6c22bcd95982bf3357747d19f40bd98297a569e9c77468b756f715"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "5bedaf2bee4c5fc9401b576f4e56848eb0b81fc9ce6ae9174009572dda490738"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d1682a7424cf30298588c37aa36158d5d39ec11729cd7dae34303d244b1ad15a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "423627352b9bd50656cb38b57ddd40faad37c001d52f9cf941a62f6d0fd0b997"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "385b4af3db0b7f734f690539553c250c0e08fb8a472c7bef07e31fb273f20fbd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b50a1157642d1cf0bca8199e5da07b8a71788775d3d1425642cfd3739ee2db26"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f6796b10d1af7ae38ed559313b5646047cb1456c66428d9c32f5e3a0981f1f4c"
    sha256 cellar: :any_skip_relocation, sonoma:         "0adf5636aa77f2f15fe9c7c1d5e97f92562c22be96cefd8a180a8e3b4886cfab"
    sha256 cellar: :any_skip_relocation, ventura:        "6a318c89f3e6924e58b9ed87ee9611260eb226a1a6ed924b176742eac2900854"
    sha256 cellar: :any_skip_relocation, monterey:       "2bbf1bbbc7bb411fe09900dbe61093834ffb41f314ba241deee6ff764c285232"
    sha256 cellar: :any_skip_relocation, big_sur:        "375c99c3793fe45e70a76ef708f9d1b8d5f4e9a7c7f64eca0f7f522926432d82"
    sha256 cellar: :any_skip_relocation, catalina:       "6a3483a957ef3a480f5391d9483b0d3cf8adfce2ec2f6b48289f16733ce29771"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "04279d34401c1e4eccc81bbd8889cf79efcdf61a2a8c228ab22497ab6b200e53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4a7cf29beb52e599c9d245d550d00848b935a8d8e5c0b9f3d46fd362e28a32b"
  end

  # adobe flash player EOL 12/31/2020, https://www.adobe.com/products/flashplayer/end-of-life-alternative.html
  deprecate! date: "2025-03-21", because: :unmaintained

  def install
    system ENV.cc, "yamdi.c", "-o", "yamdi", *ENV.cflags.to_s.split
    bin.install "yamdi"
    man1.install "man1/yamdi.1"
  end
end
