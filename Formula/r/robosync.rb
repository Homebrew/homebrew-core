class Robosync < Formula
  desc "High-performance file synchronization with intelligent concurrent processing"
  homepage "https://github.com/roethlar/robosync"
  url "https://github.com/roethlar/robosync/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "c1ca167b6ae535afa4778e779e9b37f65e9f3519919d1cba5eade9ece1745f77"
  license "MIT"
  head "https://github.com/roethlar/robosync.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Create test directories
    (testpath/"source").mkpath
    (testpath/"source/test.txt").write("Hello, RoboSync!")
    
    # Run robosync
    system bin/"robosync", testpath/"source", testpath/"dest"
    
    # Verify the file was copied
    assert_predicate testpath/"dest/test.txt", :exist?
    assert_equal "Hello, RoboSync!", (testpath/"dest/test.txt").read
  end
end