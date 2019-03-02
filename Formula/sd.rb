class Sd < Formula
  desc "Intuitive find & replace CLI"
  homepage "https://github.com/chmln/sd"
  url "https://github.com/chmln/sd/archive/sd-0.5.0.tar.gz"
  sha256 "167940e76ce0dd0129832e1cc1302eef9318f9003d27d968fbcba912ce23bb1c"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    assert_equal "after", pipe_output("#{bin}/sd before after", "before")
  end
end
