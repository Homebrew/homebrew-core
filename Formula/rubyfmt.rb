class Rubyfmt < Formula
  desc "Ruby autoformatter"
  homepage "https://github.com/penelopezone/rubyfmt"
  # pull from git tag to get submodules
  url "https://github.com/penelopezone/rubyfmt.git",
      :tag      => "v0.3.0",
      :revision => "f4296cbf9f5077ef684d9afb3c25f70db7d4c4bd"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "8d9ed80d496220e02b9df146c41870079116cf798ab90734212d3cdc6080bb8b" => :catalina
    sha256 "8d9ed80d496220e02b9df146c41870079116cf798ab90734212d3cdc6080bb8b" => :mojave
    sha256 "8d9ed80d496220e02b9df146c41870079116cf798ab90734212d3cdc6080bb8b" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "rust" => :build
  uses_from_macos "ruby"

  def install
    system "make", "submodules"
    system "make", "target/release/rubyfmt-main"
    bin.install "target/release/rubyfmt-main" => "rubyfmt"
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
