class Wgo < Formula
  desc "Watch arbitrary files and respond with arbitrary commands"
  homepage "https://github.com/bokwoon95/wgo"
  url "https://github.com/bokwoon95/wgo/archive/refs/tags/v0.5.7.tar.gz"
  sha256 "49bd5e622f04adea77d94eebfaf47934a2bde7b3bb863733d2bab28eeebcd7dd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f537c5a08b29090c71c4a70583944b417499aae36fc9558bef092f9a8441b1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f537c5a08b29090c71c4a70583944b417499aae36fc9558bef092f9a8441b1f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9f537c5a08b29090c71c4a70583944b417499aae36fc9558bef092f9a8441b1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e55ff32ecd04a049b4997262f88f89e308e41bc7f1f277b5cd4b6259d9989817"
    sha256 cellar: :any_skip_relocation, ventura:       "e55ff32ecd04a049b4997262f88f89e308e41bc7f1f277b5cd4b6259d9989817"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1be2dae5a84151eb4e4df49613d2849b22372e456212605d3a2224538f583172"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/wgo -exit echo testing")
    assert_match "testing", output
  end
end
