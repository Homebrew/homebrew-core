class Tere < Formula
  desc "Terminal file explorer"
  homepage "https://github.com/mgunyho/tere"
  url "https://github.com/mgunyho/tere/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "7db94216b94abd42f48105c90e0e777593aaf867472615eb94dc2f77bb6a3cfb"
  license "EUPL-1.2"
  head "https://github.com/mgunyho/tere.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "787e582804b995bb8b5d87d670ca4043d3647a94c11afa8e332f15656935c7ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c9a60b3dc17b2a32d0ecf1836b3914099c6ddc58f19261dae3b5fa7166b28ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec52070d45befb5b87f6e7785a336cd8966774c754bbc7a6f1f0107d66523b13"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f59761f29b1ceeb7f633056dfac46d6293ef9ff320dcf3260a2e7ce5fb7d988a"
    sha256 cellar: :any_skip_relocation, sonoma:        "65ae7c433f4610971aa049108551e70bd6b89adb5dbd0966699ed4ae7ae23aab"
    sha256 cellar: :any_skip_relocation, ventura:       "1330af75bc33de620228e27758d6bdef23e1956c7a249d3f7d6f644e4d40fa00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "175b2dacf2c4dad2c0a6f871d0225970305f240fed95724145cae5c244c59787"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9665ab7e423ec09d10dd3e85bec42d8a1e222ef3bfcfb7b229fcdafa5210d69c"
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
