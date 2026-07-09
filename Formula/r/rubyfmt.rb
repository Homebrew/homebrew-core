class Rubyfmt < Formula
  desc "Ruby autoformatter"
  homepage "https://github.com/fables-tales/rubyfmt"
  url "https://github.com/fables-tales/rubyfmt/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "e008e4ae58680ea884c525eda0df6f70f4e8629182f0808835cb4666114e3de9"
  license "MIT"
  head "https://github.com/fables-tales/rubyfmt.git", branch: "trunk"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c196e389362aa426bac9f7b0c6edf06969eef6ffdc3a477b7671e24a05b98ef9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bed4c85a6140b97fbb79e66e7cbc45361e6588b33ee3f3f943ad229a0d1a115f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b409976d32163aae6e6154aa68b36c60ed32c89196c1258bca268382cfc965bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "b886bb251833b6833016d78d916565c4e30684fd5713e828dd555099192f9693"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59b08255cd21a49004288761f58550f6f75986af8938ea9af2b838eb1b97fec4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46d538b0853be653e8c0f789d768a667b58a627fec9809ee4010de3cd71d15ff"
  end

  depends_on "rust" => :build
  uses_from_macos "llvm" => :build # for libclang to build ruby-prism-sys

  def install
    system "cargo", "install", *std_cargo_args
    bin.install bin/"rubyfmt-main" => "rubyfmt"
  end

  test do
    (testpath/"test.rb").write <<~RUBY
      def foo; 42; end
    RUBY
    expected = <<~RUBY
      def foo
        42
      end
    RUBY
    assert_equal expected, shell_output("#{bin}/rubyfmt -- #{testpath}/test.rb")
  end
end
