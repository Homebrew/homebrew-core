class Rv < Formula
  desc "Ruby version manager"
  homepage "https://github.com/spinel-coop/rv"
  url "https://github.com/spinel-coop/rv/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "3336a90e0cd559b8ba6b1887f51df78a0fb74e0e8abe858686c80e31f67fa29d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/spinel-coop/rv.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1d731aafc757d7cfb3eb2745a3ba081b0cda164baa7121213f0bdff756475182"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b62190ce98b75f8bf7c530c494c152fc965aaaf87600c7cb0a27b7742e0047e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "38b39731b4cade9a47cbb38636269b9583f74816c6a569cb147d4d8568bed686"
    sha256 cellar: :any,                 arm64_linux:       "b570d894d0ae192b5283d0021214b8376d1f4e806405adb9fc75676e8d3fb3eb"
    sha256 cellar: :any,                 x86_64_linux:      "ff49960691f25a5eeec0565576afc94d0fd5119af423f646b94b64ffc98e9278"
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
