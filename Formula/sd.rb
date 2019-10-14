class Sd < Formula
  desc "Intuitive find & replace CLI"
  homepage "https://github.com/chmln/sd"
  url "https://github.com/chmln/sd/archive/0.6.5.tar.gz"
  sha256 "ed38e5103080373b00443f72683ac2785b18e354ab6ef4797e27af028be9baf2"

  bottle do
    cellar :any_skip_relocation
    sha256 "a2270c4330760007e369fc9da739abacc3744e9a9cc987dc90fc7fc830d36ec8" => :catalina
    sha256 "bae6022d6efa72ce65337baa1be8a1b5d569905c13958be7bab9191239123297" => :mojave
    sha256 "404bbedfd604f51148f33dd9441dd93611def5ddf93c91466f44921507353e4a" => :high_sierra
    sha256 "010317dec38d6fead368fbc2b3d26c9eab2a0ea6d833ccc419484c76989e55e8" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    assert_equal "after", pipe_output("#{bin}/sd before after", "before")
  end
end
