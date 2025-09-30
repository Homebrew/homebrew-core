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

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "add7264b0c1f0f824a4cacb9207a09fd1b64af9fb800f9ac3caafa0a34ee4568"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ea996577f2010a2fcc3a4244398c2cdc8988de9efedeed1646f358798b33ab4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20e428828937e70b6c4e9dc9d742ecc1a8f331dc65369488c1fd576cb6abfe1e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d5ba71656cdf87c3c1b5a2f9664f2deb21f59a949173a9a639340617a8bc8707"
    sha256 cellar: :any_skip_relocation, sonoma:        "57a01d03aee9e206fc51d64079ab95b0974f6b0e39dc5a464e58f975a45bea0c"
    sha256 cellar: :any_skip_relocation, ventura:       "b831dd07102b2eabadfaf38c84cfe0d24a5ed7d6c7ca3b58702eb7dfe5f7dd5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d5ab407a571c5ce85baf2a784dde2b0a523614d749df8aed8c0d4b03af472b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7268052db591d14ad85711a47d0ce9b9578a0c9a0d353e63b870231d358478e"
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
    ENV.append_to_rustflags "--allow dead_code"

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
