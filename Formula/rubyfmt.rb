class Rubyfmt < Formula
  desc "Ruby autoformatter"
  homepage "https://github.com/penelopezone/rubyfmt"
  url "https://github.com/penelopezone/rubyfmt.git",
    tag:      "v0.8.1",
    revision: "266b47b4666106e579626b1823100ccedf5cbbc3"
  license "MIT"
  head "https://github.com/penelopezone/rubyfmt.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ffe2557b460a78c161959cc03999ad288d33ade3e4f73f412fd24b2f465b7601"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0dfe25a13c4da055ae4ff958e30e308df845672985bf5b22ff659304716f556f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "09a2ee947086e1b2b8bd58c077a23279e13439ec1e5ba915ebaaf78bb1368da7"
    sha256 cellar: :any_skip_relocation, monterey:       "e3c7a4b275561ff64c5df8c0bd1c829f8366ed9d943e45c75e8c716ea2a77bd9"
    sha256 cellar: :any_skip_relocation, big_sur:        "4cc3b3a8c815a97fb043ddccbd6af3686dee3abfa863b64f7cc8f89c1c772aed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb93fe3e235c3b4e177e7287e1a0aef59f547ff2100f28ee62ae51534e6c0260"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "rust" => :build
  uses_from_macos "ruby"

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
