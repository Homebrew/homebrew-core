class Rubyfmt < Formula
  desc "Ruby autoformatter"
  homepage "https://github.com/fables-tales/rubyfmt"
  url "https://github.com/fables-tales/rubyfmt.git",
    tag:      "v0.9.5",
    revision: "46e08ebde71f5e816bdde0065c5100f33ee638a7"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d09a3a4d1c12a51b7089fd7554c0aace9cf01aa9cd210160b916da9ba201d7d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7792ccbf555b666ed796bcd19fcc9437fca0ba305f3b411163adb04aefbd5eb8"
    sha256 cellar: :any_skip_relocation, ventura:        "2d37979f16e2e376c0719df485922a6aa4f68c0d85797ea918b93e16499c2554"
    sha256 cellar: :any_skip_relocation, monterey:       "bfb1947a9f36e056edff55e5d300da4d63becc2f2f990d5df5f57c194abb5ff0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38fe5b3aaa09f9bc6d57a2119152b116813702fe98daf0a1e654c8cd4b5e1e4d"
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
