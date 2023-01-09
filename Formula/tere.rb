class Tere < Formula
  desc "Terminal file explorer"
  homepage "https://github.com/mgunyho/tere"
  url "https://github.com/mgunyho/tere/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "84eeafc346ee2207bcfb0a9e29a6a4e7748817741a0f7245a204d16da0ef651f"
  license "EUPL-1.2"
  head "https://github.com/mgunyho/tere.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c521fead524aa19c097fe0f6abf4eb0adf78226b0a0cdced4b29baa9f1dd1412"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1389effb508cdd8a0d7211bf5cb072184964e474af7c96d2a427c5f311c2c24"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "850594f81805b217285fd40350f24c2e215222855987ac1a6519f8f23b8eace2"
    sha256 cellar: :any_skip_relocation, ventura:        "a85d6a16b1460705cb227cde2f4cffd8193dbf44ef2bdb92b80698403436c8e6"
    sha256 cellar: :any_skip_relocation, monterey:       "c80aa388ca04956ba77ba6f7ea78618b6712a4e74276b9de3d7e308eedb926d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "582de3e454d9d6b4820598f95de6d46cc85d96df0be8730d458234e12274a659"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "113b1a429c84c335ddaea384e2c06a6cb93b0f8a741c9a445c9c07fbc0d4a9cc"
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
