class Rubyfmt < Formula
  desc "Ruby autoformatter"
  homepage "https://github.com/fables-tales/rubyfmt"
  url "https://github.com/fables-tales/rubyfmt/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "6972f8083a199bee4825ba03805baebd6e4203c543b5f96b716d6964f5628a87"
  license "MIT"
  head "https://github.com/fables-tales/rubyfmt.git", branch: "trunk"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1ae4924754e4f83c5911314dec2ec3ff4dd4c1cfdf5257223e86742e9c3f842"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ae3190fb8ad78610482263d7c3ae7b3b5b8377aded523633a9a9a2237ccb977"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7aef931acdfdf3e26dc32a5cbe679d51d8e291011d05b2c6089b34445202d17"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c4a05cd5fc646ad2fdf873a63fff26b14b4b2299157065691e881445a5bc4e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2637212bf431afef2a0ae70cea03375fa53cb6602f39b7d88a9deb0f4c2dd7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de56de3073592a683d1f8b29dd696eb723b8a818ee57fc2d237052fdd3133e4b"
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
