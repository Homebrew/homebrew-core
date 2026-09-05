class Rv < Formula
  desc "Ruby version manager"
  homepage "https://github.com/spinel-coop/rv"
  url "https://github.com/spinel-coop/rv/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "c7d6c173ea022b9eec1eca727859e33a9c8fd68a5aac147ebf5e351df7f0d9e1"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/spinel-coop/rv.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6f717b3373c31e905d7161c7c98bd234a64acb55d36a98e93b8ae59fe000aa4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44a546367812a15b6858e228b58ed498d0daaa5cf586b7ca2955838d3a87dbf8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b833ca6c86bb04cc4d540de5fc4d4b2011218d1aac5cd779969716ccd43da30"
    sha256 cellar: :any,                 arm64_linux:   "ad4a81d83444606c51aebc7497845454b9ba9285f4f9a75008ee735dc69db4e7"
    sha256 cellar: :any,                 x86_64_linux:  "4c91c25d253f5e8ae368b058075d0250f4d0593784a73fcc4d2f4a11c91d4168"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang

  on_macos do
    depends_on macos: :sonoma
  end

  conflicts_with "rv-r", because: "both install `rv` binary"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/rv")
    generate_completions_from_executable(bin/"rv", "shell", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rv --version")
    assert_match "No Ruby installations found.", shell_output("#{bin}/rv ruby list --installed-only 2>&1")
    (testpath/"hello.rb").write <<~RUBY
      puts "Homebrew"
    RUBY
    assert_match "Homebrew", shell_output("#{bin}/rv run --ruby 3.4.5 hello.rb")
  end
end
