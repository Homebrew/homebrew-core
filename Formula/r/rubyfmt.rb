class Rubyfmt < Formula
  desc "Ruby autoformatter"
  homepage "https://github.com/fables-tales/rubyfmt"
  url "https://github.com/fables-tales/rubyfmt/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "18964b26fda04549ee1a7b9b6a413775661f7d39595d90bf603f4c373cf373ca"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6abe58bc74b6efaf266a6d4c0d030d0bd03eb9fede6646c989369de3f916b380"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0928934ba9c20c01523cb0b18ded982fa4128af0a3a8848dda3434f031e6a58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8088a4968d835b33d53eb82c6752fc2bd6342f43ab57bb54f1c2f502786994f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "e617fc6c14cf0934a27c3a25c8816113ffba1a1a5b1c55e8ad64d9cb69d6c2eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c16d746c55a73664697cb31eba97ff478e22452525f860de482b5730804ce196"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b801d8c0a8e81abbfc7ce88850f78bf5e6f0b22e67616bfcc663051c49debfbf"
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
