class Sd < Formula
  desc "Intuitive find & replace CLI"
  homepage "https://github.com/chmln/sd"
  url "https://github.com/chmln/sd/archive/v0.7.6.tar.gz"
  sha256 "faf33a97797b95097c08ebb7c2451ac9835907254d89863b10ab5e0813b5fe5f"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "649c660b6e8a4a77e5fc9dd12b1aa28a59212f676d2394f7e3ea682a9d3cc533" => :catalina
    sha256 "1b451f55b69988e53a7699005f5aac1e50ed30e466ea0bbf1b30d382887360b1" => :mojave
    sha256 "971451d1dd8fb3340c9c5a74ea20769e114362e84b0f9bb9a0ead52881c71196" => :high_sierra
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
