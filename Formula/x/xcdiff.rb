class Xcdiff < Formula
  desc "Tool to diff xcodeproj files"
  homepage "https://github.com/bloomberg/xcdiff"
  url "https://github.com/bloomberg/xcdiff.git",
    tag:      "0.12.0",
    revision: "8ae8a1074662dfbef271140bfb4ae424b331dde9"
  license "Apache-2.0"
  head "https://github.com/bloomberg/xcdiff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4832eb6d349280c80983cdbe96bf82e7e50c90b84415af332f9d052d2e45a67c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae3e9ee0a986720d74a76539312f5a3d7c2e1ea4551863ecc87da4438dd94c5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3fe13c6d9dff8984aa4a448e01cefeec459bd5ab2a0ee0c7334de9671d4ba1d0"
    sha256 cellar: :any_skip_relocation, sonoma:         "b369ccc6c11ee006349b4c35579eaec40f0d80e5bbbae8d5fdd87ed2af1169a9"
    sha256 cellar: :any_skip_relocation, ventura:        "066813b4a4cf35c7a0b07f4927abcebd97dee931d0c3f0cd19a57eae07eb7864"
    sha256 cellar: :any_skip_relocation, monterey:       "3e462aeba27a92ed9e1c7c532891ed6eef0d73f27396c389acd2855a9462ca9d"
  end
  depends_on :macos
  depends_on xcode: "14.1"

  resource "homebrew-testdata" do
    url "https://github.com/bloomberg/xcdiff/archive/refs/tags/0.10.0.tar.gz"
    sha256 "c093e128873f1bb2605b14bf9100c5ad7855be17b14f2cad36668153110b1265"
  end

  def install
    system "make", "update_version"
    system "make", "update_hash"
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/xcdiff"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xcdiff --version").chomp
    project = "Fixtures/ios_project_1/Project.xcodeproj"
    diff_args = "-p1 #{project} -p2 #{project}"
    resource("homebrew-testdata").stage do
      # assert no difference between projects
      assert_equal "\n", shell_output("#{bin}/xcdiff #{diff_args} -d")
      out = shell_output("#{bin}/xcdiff #{diff_args} -g BUILD_PHASES -t Project -v")
      assert_match "✅ BUILD_PHASES > \"Project\" target\n", out
    end
  end
end
