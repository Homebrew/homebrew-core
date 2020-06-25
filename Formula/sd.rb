class Sd < Formula
  desc "Intuitive find & replace CLI"
  homepage "https://github.com/chmln/sd"
  url "https://github.com/chmln/sd/archive/v0.7.5.tar.gz"
  sha256 "f4731fd6bd992eed06ed9326cdef22093605ff97df1dd856e31c5015f0720c66"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "cc2d08fca64a765bc5df67fc69b23f4afa3350c0851fabd06d4e3b218c456bb2" => :catalina
    sha256 "6496955ab15f26f18111214c0b97c24143f752aa4b222b6c54b15e24c5ee1462" => :mojave
    sha256 "0cdf79c329703411f1e67a4ff85fd58f10bd6de5293c1a5b7983c56b3defd7a4" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    # Completion scripts and manpage are generated in the crate's build
    # directory, which includes a fingerprint hash. Try to locate it first
    out_dir = Dir["target/release/build/sd-*/out"].first
    man1.install "#{out_dir}/sd.1"
    bash_completion.install "#{out_dir}/sd.bash"
    zsh_completion.install "#{out_dir}/_sd"
  end

  test do
    assert_equal "after", pipe_output("#{bin}/sd before after", "before")
  end
end
