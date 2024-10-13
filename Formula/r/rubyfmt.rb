class Rubyfmt < Formula
  desc "Ruby autoformatter"
  homepage "https://github.com/fables-tales/rubyfmt"
  url "https://github.com/fables-tales/rubyfmt.git",
    tag:      "v0.10.0",
    revision: "e00d2ab89fd4b0b85a7897fac393c1ad987136de"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8793acc1768054494843921cbf1708faea486a165a21d6f346afc721284057f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "53a6870d51b42778724d9f6d051a16e2769701cf3c4946d5b464ac0da0656fe5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd0e320c01c7848a26b51e6d06f9d96d2d8d765eb4b943ca570a546bc063d503"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54ac9bdaab5905b208a7b80f6f8c1f0fd6752636821322d27d33458cd94988fd"
    sha256 cellar: :any_skip_relocation, sonoma:         "72a7b6f0425b6ff0ad1bd324db39cf6dfca154dbfa71eae087088fd22254e84a"
    sha256 cellar: :any_skip_relocation, ventura:        "733d2fe74b0a32666b708b5b265302268dcc088c897798380f2c6f677e06c707"
    sha256 cellar: :any_skip_relocation, monterey:       "00f60ebdde76b0ac30df678b597e2b184b65146021099f8fecde4a36fb7cf4f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d10a98c28284d130b05f63649d4e89bbdd73b57d1522b0b2fc1ca3f4ddce973"
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
