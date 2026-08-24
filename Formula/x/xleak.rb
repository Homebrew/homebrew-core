class Xleak < Formula
  desc "Terminal Excel viewer with an interactive TUI"
  homepage "https://github.com/bgreenwell/xleak"
  url "https://github.com/bgreenwell/xleak/releases/download/v0.2.6/source.tar.gz"
  sha256 "044f69f844e16259ed8f052a4c626032d2b147b0d63b36fc743e87a35e5696cb"
  license "MIT"
  head "https://github.com/bgreenwell/xleak.git", branch: "devel"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14ade8276fec7fa62c7da39e7807e536862bb932fcb24de73242d34b56e88c1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b4ed79469e9eedc6aeac6a814098ff6bd105cc6ffa8d07b4c743653b068b8c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1acb59afb191b7f8a405bc5c06d9fd9ce38acf95d5656ab2592eafe5724649e"
    sha256 cellar: :any_skip_relocation, sonoma:        "781a1471106577c6e2ac4e6125e50b0eb1ab6cc7138b0552108120683d2c5f7e"
    sha256 cellar: :any,                 arm64_linux:   "bcdde47d70673544d06122740138000e125fdef2ebcd4ab3e803333d2818e88d"
    sha256 cellar: :any,                 x86_64_linux:  "5fdb88fde4eeef24e605a317bbde5008e89a02967962ea0e4263063b9d9e7f71"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xleak --version")

    resource "testfile" do
      url "https://github.com/chenrui333/github-action-test/releases/download/2025.11.16/test.xlsx"
      sha256 "1231165a2dcf688ba902579f0aafc63fc1481886c2ec7c2aa0b537d9cfd30676"
    end

    testpath.install resource("testfile")
    output = shell_output("#{bin}/xleak #{testpath}/test.xlsx")
    assert_match "Total: 5 rows × 2 columns", output
  end
end
