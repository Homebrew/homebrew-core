class Tere < Formula
  desc "Terminal file explorer"
  homepage "https://github.com/mgunyho/tere"
  url "https://github.com/mgunyho/tere/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "84eeafc346ee2207bcfb0a9e29a6a4e7748817741a0f7245a204d16da0ef651f"
  license "EUPL-1.2"
  head "https://github.com/mgunyho/tere.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef5700c2c16806ea8a897fe07cde0827a1bb8dac5ab31eba477f345b2702fb74"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3501e78bf1eb19fe26d5c7775fd6e140dad214c77cae5d186aded432a71a66c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7ead8588e0ea220d7d0bc96e53676d49d6275dd3b7d9044bc43a6e4f0994a8b"
    sha256 cellar: :any_skip_relocation, ventura:        "e00826c7cf06813ebd5773e2bafcfad70197e23a896363a2a8e992ee5f41f2af"
    sha256 cellar: :any_skip_relocation, monterey:       "3baa642216e631cf11aac5ce96b8fdacdf87df96bb8134e1a15f332bc1c950ff"
    sha256 cellar: :any_skip_relocation, big_sur:        "1582432f2ef98ac6440e14c869dc4b8f34d43a6e523698e707e6588e7701f479"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a0c2e58c1141a19bcf069d8e371fcf6c9d184018290d265e718c0b0946b3a1e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Launch `tere` and then immediately exit to test whether `tere` runs without errors.
    PTY.spawn(bin/"tere") do |r, w, _pid|
      r.winsize = [80, 43]
      sleep 1
      w.write "\e"
      begin
        r.read
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end
  end
end
