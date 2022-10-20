class Tere < Formula
  desc "Terminal file explorer"
  homepage "https://github.com/mgunyho/tere"
  url "https://github.com/mgunyho/tere/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "000d597c731f7c69175c6c50ccb20a3f508122e678b46d9fd89736ff7f0ea60e"
  license "EUPL-1.2"
  head "https://github.com/mgunyho/tere.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c6b5419ca46e83391cfce712361640ebf2c2605e0be079e32f9616baa7729d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "44400ec974be0be0d8125944538726881e7756872b5230a55b873e056134bc62"
    sha256 cellar: :any_skip_relocation, monterey:       "573bba62faa4daa9ec7cab4ab2ceac25f27c6ea493b11b430eaea45db679f226"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e94cd44fc296dba1d9b68afa56b438406b29657e076a61b8b65e0afdd706cb9"
    sha256 cellar: :any_skip_relocation, catalina:       "6fb8786fad2b2ec0664af01cf7b711a54bdd09c95dae479e1f020f7fd8add0a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "100a5c9977474ef2c96e220e2930d53af4f15eb17ca7e3b5cc6615b15cc2d0f5"
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
