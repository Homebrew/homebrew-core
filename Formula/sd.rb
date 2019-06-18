class Sd < Formula
  desc "Intuitive find & replace CLI"
  homepage "https://github.com/chmln/sd"
  url "https://github.com/chmln/sd/archive/0.6.4.tar.gz"
  sha256 "ceb29887826b9b5c56990ca9dc81a3e6177a0e08424954f4d80e76c413591a8d"

  bottle do
    cellar :any_skip_relocation
    sha256 "f29e123a8903bd9b50b9fc791e55ac0c0b0ad5c5a3822a2a6e09641af289fe6c" => :mojave
    sha256 "e82a75b97a79f9408070df0bf791e3450a5f4e95e5cab6f07eed6b467c7abe3f" => :high_sierra
    sha256 "bfe0707d957478d2ad272cb9dda51db8a4c87fbbca210978bb27845d28e025c3" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    assert_equal "after", pipe_output("#{bin}/sd before after", "before")
  end
end
