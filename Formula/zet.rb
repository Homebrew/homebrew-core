class Zet < Formula
  desc "CLI utility to find the union, intersection, and set difference of files"
  homepage "https://github.com/yarrow/zet"
  url "https://github.com/yarrow/zet/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "0b48903a3fad9e8024b667032e873c2758cd6b856682b1f59fe9e9c0fc35642d"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix
  end

  test do
    (testpath/"foo.txt").write("1\n2\n3\n4\n5\n")
    (testpath/"bar.txt").write("1\n2\n4\n")
    resource("testdata").stage do
      assert_equal "3/n5/n",
      shell_output("#{bin}/zet diff foo.txt bar.txt")
    end
  end
end
