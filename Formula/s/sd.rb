class Sd < Formula
  desc "Intuitive find & replace CLI"
  homepage "https://github.com/chmln/sd"
  url "https://github.com/chmln/sd/archive/v0.7.6.tar.gz"
  sha256 "faf33a97797b95097c08ebb7c2451ac9835907254d89863b10ab5e0813b5fe5f"
  license "MIT"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "271c6437b052266f984385bc9b2c858f5b3a49b64dc2cc5b7c6d59ee1f8b5fd6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "835707d1e97370f90da250af0530a0fbeac76a5dc9ffb23f9fe3bcae92de89dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9cff9381bd1df190b0ce4f1707d06b061f4f3da260feffd6598d0f8bfc1862b1"
    sha256 cellar: :any_skip_relocation, ventura:        "7a96cfa7331341b29fd88b3db25b2c18467e93cbfc7c0045bc923c0aabfe361d"
    sha256 cellar: :any_skip_relocation, monterey:       "dcbc3366946b79448289b73a88e26e2686a9847fe8c6f68abe6e421e54a23551"
    sha256 cellar: :any_skip_relocation, big_sur:        "d33e64b4ef076ac70f487f5095b94ce9d9f306ba8036f2015cfa381fbcec86aa"
    sha256 cellar: :any_skip_relocation, catalina:       "4361d802ac3d701e6779538f8329148635c9facac816d04df5efd75928d6186f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2314e052715a9a728694c5dead51555f276b7e51cea9c1bf7be6e1e51af0bfe8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    # Completion scripts and manpage are generated in the crate's build
    # directory, which includes a fingerprint hash. Try to locate it first
    out_dir = Dir["target/release/build/sd-*/out"].first
    man1.install "#{out_dir}/sd.1"
    bash_completion.install "#{out_dir}/sd.bash"
    fish_completion.install "#{out_dir}/sd.fish"
    zsh_completion.install "#{out_dir}/_sd"
  end

  test do
    assert_equal "after", pipe_output("#{bin}/sd before after", "before")
  end
end
