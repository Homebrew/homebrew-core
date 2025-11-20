class Unz < Formula
  desc "Univeral unpacker with sane defaults"
  homepage "https://git.sr.ht/~birkedal/unz"
  url "https://git.sr.ht/~birkedal/unz/archive/v1.0.0.tar.gz"
  sha256 "96d8bb76a2f5dbed7223c702f04791eba3e63fdca2551429e9b16265726e5c72"
  license "MIT"
  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # Create a simple test archive
    (testpath/"test.txt").write "Hello, Homebrew!"
    system "tar", "-czf", "test.tar.gz", "test.txt"

    # Test unpacking
    mkdir "output"
    system bin/"unz", "--no-progress", "test.tar.gz", "output"
    assert_path_exists testpath/"output/test.txt"
    assert_match "Hello, Homebrew!", (testpath/"output/test.txt").read
  end
end
