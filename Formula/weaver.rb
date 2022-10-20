class Weaver < Formula
  desc "Command-line tool for Weaver"
  homepage "https://github.com/scribd/Weaver"
  url "https://github.com/scribd/Weaver/archive/1.1.3.tar.gz"
  sha256 "d1fd7d767a4b5cea852378046c6bc9eb50a252aeb3dc96feb5c0128c60472f96"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93d751d566f124f72ea5e7e5f69d02fcd8e4dc8a42e1d727b32e5d89358186c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dce6df313bda1d4a884d9cdb4bbe9a7b945beed812de37962817d877354cf221"
    sha256 cellar: :any_skip_relocation, monterey:       "226ea9a827d1b648cf94081eeec60b8b8118517b99c249b7baa7f0019ce351ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "f501f9389156b9ae1d92c635e0cbaf949b128f37bd48ef8ac85c0af244d3be3b"
    sha256 cellar: :any_skip_relocation, catalina:       "4c7a13adc6388d49efcb4fcf7c7634ac5fae58e8771f319bc5e2db0af5166f82"
  end

  depends_on xcode: ["11.2", :build]

  uses_from_macos "swift"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Weaver uses Sourcekitten and thus, has the same sandbox issues.
    # Rewrite test after sandbox issues investigated.
    # https://github.com/Homebrew/homebrew/pull/50211
    system bin/"weaver", "version"
  end
end
