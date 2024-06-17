class Uni < Formula
  desc "Unicode database query tool for the command-line"
  homepage "https://github.com/arp242/uni"
  url "https://github.com/arp242/uni/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "192f904eda8cd9f3dce002bc04a5c622ea113c269d4b1a19f4c89094b05f9cd9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7d5176fe6c7bbe6d4d6bcfff85949f75756c5fd22a5adba52c673ce12d5a3141"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d5176fe6c7bbe6d4d6bcfff85949f75756c5fd22a5adba52c673ce12d5a3141"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d5176fe6c7bbe6d4d6bcfff85949f75756c5fd22a5adba52c673ce12d5a3141"
    sha256 cellar: :any_skip_relocation, sonoma:         "bcef03aeab1f7d2aaef3e0e03143e63903ff117a006e360ab843917333bf4b91"
    sha256 cellar: :any_skip_relocation, ventura:        "bcef03aeab1f7d2aaef3e0e03143e63903ff117a006e360ab843917333bf4b91"
    sha256 cellar: :any_skip_relocation, monterey:       "bcef03aeab1f7d2aaef3e0e03143e63903ff117a006e360ab843917333bf4b91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97376c272b3d1fce79a92a6823f4afd08e1bd235ee705d7340cacf53e3ba38c7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "CLINKING BEER MUGS", shell_output("#{bin}/uni identify 🍻")
  end
end
