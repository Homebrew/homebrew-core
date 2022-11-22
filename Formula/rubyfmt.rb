class Rubyfmt < Formula
  desc "Ruby autoformatter"
  homepage "https://github.com/penelopezone/rubyfmt"
  url "https://github.com/penelopezone/rubyfmt.git",
    tag:      "v0.8.0",
    revision: "ed99cc4586a908c97f8b19ed78801342f7aa8512"
  license "MIT"
  head "https://github.com/penelopezone/rubyfmt.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f218d7b1b26f6a4818d1d398f103b68a1d6fe75fca7077e8781f45033cf3d4b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d839898bf5809b19cb31bed03f174c2d335193daf0ae3f7eba722d3c075df6d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc069ca891bc56b61dc47a060329a14376baf59fd3f207aa50e831555f28aa86"
    sha256 cellar: :any_skip_relocation, monterey:       "ef4a822468573167fe1cea652bdddd42d9c61547f639fe2518d672e88bf37e55"
    sha256 cellar: :any_skip_relocation, big_sur:        "869db78a409c39560aff03c6e54c99c344c35d6dd1d43705ba2ac086f53e0af3"
    sha256 cellar: :any_skip_relocation, catalina:       "7206819d3053e1d6dbe1b194f5eeb1550a6b88f7c899ec0b533a7aed93ac6bc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d512052245d378b1d6b9fc9cc04783bd26cbb70980cc530f81f7e4f36c23d80f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "rust" => :build
  uses_from_macos "ruby"

  # This patch includes a fix for Big Sur ARM builds which was not included in the 0.8.0
  # release. This should be removed for future releases, which should include this patch.
  patch do
    on_big_sur do
      url "https://github.com/penelopezone/rubyfmt/commit/8a193552e6b8232d44347505f4cd503c800161a3.patch?full_index=1"
      sha256 "936734916d24233c03e986ded729b2cc0a3ebce4180136bcfd845dfef8b1f4c5"
    end
  end

  def install
    system "cargo", "install", *std_cargo_args
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
    assert_equal expected, shell_output("#{bin}/rubyfmt -- #{testpath}/test.rb")
  end
end
