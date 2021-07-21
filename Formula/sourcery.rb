class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/1.5.0.tar.gz"
  sha256 "df21295ae7cd309e7c1d6687aeee6e12a2677af2faf0da39bfd23d188ef12b08"
  license "MIT"
  head "https://github.com/krzysztofzablocki/Sourcery.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "bbdf8fab133cbe83bcf468effd3ee726a607495f6a43c64f4276e469ddd2a936"
    sha256 cellar: :any, big_sur:       "ca698b6ec73765d6fa0a65888258246a493134f90915c4699f6cde4ad259f442"
    sha256 cellar: :any, catalina:      "85b8f8e922d4f6169e38fd7ea0a3afc1187fc8fe887b2477a3b495bb2d8218ed"
  end

  depends_on xcode: "12.0"
  uses_from_macos "ruby" => :build

  def install
    system "rake", "build"
    bin.install "cli/bin/sourcery"
    lib.install Dir["cli/lib/*.dylib"]
  end

  test do
    # Regular functionality requires a non-sandboxed environment, so we can only test version/help here.
    assert_match version.to_s, shell_output("#{bin}/sourcery --version").chomp
  end
end
