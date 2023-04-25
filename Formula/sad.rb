class Sad < Formula
  desc "CLI search and replace | Space Age seD"
  homepage "https://github.com/ms-jpq/sad"
  url "https://github.com/ms-jpq/sad/archive/refs/tags/v0.4.22.tar.gz"
  sha256 "cc3f66432ad2b97b1991afe8400846c64ba7d0a65d6c9615bcdf285d7a534634"
  license "MIT"
  head "https://github.com/ms-jpq/sad.git", branch: "senpai"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76a49058ef46cd3dcabf7dd5aa7c0778732d82856604d43c12a24cd41703c4d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b3a71a2872f8e025029f56f80453b116fc1fb98057c57f9484f305a237dd830"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5a0e1bb15571ad9bdbc46f89a88b24de047a7af63240aa3b68a2c5bf2c4815b"
    sha256 cellar: :any_skip_relocation, ventura:        "93dc0c849f406efadafc01ae3132df6c2168676828642e9197faae390aa09117"
    sha256 cellar: :any_skip_relocation, monterey:       "5654280b37a8f81aa2dc514cf93f54749760da29057c9f4ddd84eb4fc3909528"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b5dde1dba02d8af92b715b0d159941e8a83a6cdb2d85eb0da7fab6413b67799"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "334996b3446019825d9c123b082e52b7aff66ad583eaa6babccc93988b1bf758"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    test_file = testpath/"test.txt"
    test_file.write "a,b,c,d,e\n1,2,3,4,5\n"
    system "find #{testpath} -name 'test.txt' | #{bin}/sad -k 'a' 'test' > /dev/null"
    assert_equal "test,b,c,d,e\n1,2,3,4,5\n", test_file.read

    assert_match "sad #{version}", shell_output("#{bin}/sad --version")
  end
end
