class Rubyfmt < Formula
  desc "Ruby autoformatter"
  homepage "https://github.com/fables-tales/rubyfmt"
  url "https://github.com/fables-tales/rubyfmt.git",
      tag:      "v0.11.0",
      revision: "55f41919cf5779fb9e2c410c04e2f613f7d79f2b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96c578513b4ad8026f8c6202855fbbb50d8f22a1f06fa24672e6d4537bebe3cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd1e916ff9236b322ef2fe242e95ff19b0ba244b7798b637c60458e0f9e72311"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "deb61a20206f73f26f5333e4691e3436648a6d5f63b20b5f8c13ff5813dc7853"
    sha256 cellar: :any_skip_relocation, sonoma:        "0abd972a5129624c5d8b8410a1fbc14ca32e6cf747948f15bc51a1976fc0b04d"
    sha256 cellar: :any_skip_relocation, ventura:       "f102e74c060458edffe138f457118d18ba73198c77bdb01969fb19d9e8f648b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4839872a36a77a8cf8b14e9c28ec240524417855d86f715325c33c400971b1ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b05509047cd3d31b41d81781cf1db098939b0a6a52848fc861f3b2a71a180d38"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "rust" => :build
  # https://bugs.ruby-lang.org/issues/18616
  # error: '__declspec' attributes are not enabled;
  # use '-fdeclspec' or '-fms-extensions' to enable support for __declspec attributes
  depends_on macos: :monterey
  uses_from_macos "ruby"

  def install
    # Work around build failure with recent Rust
    # Issue ref: https://github.com/fables-tales/rubyfmt/issues/467
    ENV["RUSTFLAGS"] = "--allow dead_code"

    system "cargo", "install", *std_cargo_args
    bin.install "target/release/rubyfmt-main" => "rubyfmt"
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
