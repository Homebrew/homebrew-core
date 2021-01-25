class Rubyfmt < Formula
  desc "Ruby autoformatter"
  homepage "https://github.com/penelopezone/rubyfmt"
  url "https://github.com/penelopezone/rubyfmt/archive/v0.2.0.tar.gz"
  sha256 "68ebc0fd30933b1e27b609cc34c69a3bc886747d11c5b949e460ce01814adaeb"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "bcdd675a98a38a40e6fa8a7bbb780524665c863bd3fefda5e222d952363630a2" => :big_sur
    sha256 "93a5eab5b30e0ff0728557a9f51ce501cc9454fb7c6616b89f5a41d7be96e493" => :arm64_big_sur
    sha256 "8d9ed80d496220e02b9df146c41870079116cf798ab90734212d3cdc6080bb8b" => :catalina
    sha256 "8d9ed80d496220e02b9df146c41870079116cf798ab90734212d3cdc6080bb8b" => :mojave
    sha256 "8d9ed80d496220e02b9df146c41870079116cf798ab90734212d3cdc6080bb8b" => :high_sierra
  end

  uses_from_macos "ruby"

  def install
    system "make"
    bin.install "build/rubyfmt.rb" => "rubyfmt"
  end

  test do
    (testpath/"test.rb").write <<~EOS
      def foo; 42; end
    EOS
    expected = <<~EOS
      def foo
        42
      end
    EOS
    assert_equal expected, shell_output("#{bin}/rubyfmt #{testpath}/test.rb")
  end
end
