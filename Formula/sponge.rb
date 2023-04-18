class Sponge < Formula
  desc "Soak up standard input and write to a file"
  homepage "https://joeyh.name/code/moreutils/"
  url "https://git.joeyh.name/index.cgi/moreutils.git/snapshot/moreutils-0.67.tar.gz"
  sha256 "03872f42c22943b21c62f711b693c422a4b8df9d1b8b2872ef9a34bd5d13ad10"
  license "GPL-2.0-only"

  livecheck do
    url "https://git.joeyh.name/index.cgi/moreutils.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce141b2e0b0de716b47b7fc80353fd0c7ca558da0aef82ae1d304f952e3ebfad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a57254622412effd18a9e7d88753c708c02cb6081d6e899b96daa3eec759a957"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17b9a2476a46979dcebe8a8902946e1d03554dd197df116ebeaba653aaabbac9"
    sha256 cellar: :any_skip_relocation, ventura:        "5adfcc6aea4ee0a9713fbac7c112b535ba54cf1e53c3d82f3d7d6f6695203824"
    sha256 cellar: :any_skip_relocation, monterey:       "4f9f96e4c0aeda3b3e7902a4154442ee6273a2a439e3ba06786b4ece8754b2ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a4fdc2bfe3320b1e048dbc449e0db5399400428cdfed8d8715fef75efbb9255"
    sha256 cellar: :any_skip_relocation, catalina:       "152ec9fb508d0b368bc9d217f424236c45ef1766dd8d56d9a17eda638e8b38e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96b0fb51813140afe463f01ef509665eb4fa8e46b4bbbb6baaa42796101f8d33"
  end

  conflicts_with "moreutils", because: "both install a `sponge` executable"

  def install
    system "make", "sponge"
    bin.install "sponge"
  end

  test do
    file = testpath/"sponge-test.txt"
    file.write("c\nb\na\n")
    system "sort #{file} | #{bin/"sponge"} #{file}"
    assert_equal "a\nb\nc\n", File.read(file)
  end
end
