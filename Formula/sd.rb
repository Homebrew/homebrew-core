class Sd < Formula
  desc "Intuitive find & replace CLI"
  homepage "https://github.com/chmln/sd"
  url "https://github.com/chmln/sd/archive/sd-0.5.0.tar.gz"
  sha256 "167940e76ce0dd0129832e1cc1302eef9318f9003d27d968fbcba912ce23bb1c"

  bottle do
    cellar :any_skip_relocation
    sha256 "2ef40ee6cd82ad31faaf71d521d4b264c4e225b749431cd5db84c8925c5aaa22" => :mojave
    sha256 "65af2c3632324146f7bc702bfb2bc0057104f9fe7c5fc1201d7994ec8851e7f7" => :high_sierra
    sha256 "c44ff0462e42083b3cf05c7337d3fbed1c4e6889c3daa2c409896435a2288ffd" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    assert_equal "after", pipe_output("#{bin}/sd before after", "before")
  end
end
