class Uni < Formula
  desc "Unicode database query tool for the command-line"
  homepage "https://github.com/arp242/uni"
  url "https://github.com/arp242/uni/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "dc9b5081279b03b8ffcf1120d3a12635acade73d43abf6a511e3453aa0180e1f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aa3b7279dc2c2bc79cb3e5dcf6b371ba6012c137f1ed54bcf0aaef7a3e20f8ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa3b7279dc2c2bc79cb3e5dcf6b371ba6012c137f1ed54bcf0aaef7a3e20f8ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa3b7279dc2c2bc79cb3e5dcf6b371ba6012c137f1ed54bcf0aaef7a3e20f8ed"
    sha256 cellar: :any_skip_relocation, sonoma:         "c784f3b7ae14f4b197b6ebe63b339afe482f4946bebe8afd5033691e51c1d31e"
    sha256 cellar: :any_skip_relocation, ventura:        "c784f3b7ae14f4b197b6ebe63b339afe482f4946bebe8afd5033691e51c1d31e"
    sha256 cellar: :any_skip_relocation, monterey:       "c784f3b7ae14f4b197b6ebe63b339afe482f4946bebe8afd5033691e51c1d31e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f4adbbcf33e46fc73a9fae2f5d20c897cdba8ac481bfd8cd8c7ecbcaaa9adbe"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "CLINKING BEER MUGS", shell_output("#{bin}/uni identify 🍻")
  end
end
