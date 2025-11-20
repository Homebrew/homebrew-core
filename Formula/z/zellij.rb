class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/refs/tags/v0.43.1.tar.gz"
  sha256 "e9fd24190869be6e9e8d731df2ccd0b3b1dd368ae9dbb9d620ec905b83e325ec"
  license "MIT"
  head "https://github.com/zellij-org/zellij.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2bd83eaf5758491245bad2de7b8c419052fdbeb6a88cf211376ad36ef6ee564"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9adef9ca8d8f602aa6fc8235a7819782f62763cb25d73bae2ad07275fcf5241"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "872cdd13e33851be3228d5439a58a2660d7eb4e352fcefa0907224009fc8e1cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "36332dd95508a9a366627930f1d0046cb64d146e1cde27fcd29d59ddb79a1627"
    sha256 cellar: :any_skip_relocation, sonoma:        "3105542ca9a5c013c712429ac137b40311f688028475e9fc098f7ec4be27d65e"
    sha256 cellar: :any_skip_relocation, ventura:       "54588e7796ad074ba96752ad696178c3424c36a1d9b7fcf7d5a0706a3940a7f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b22bc4639dffd8290662403848742f65984dc26f17704f34eeef02b03e6a9748"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f4dd025402c9ad4ee3168b8d57c08a9657761343a3eef7fd93c91921a3bac3c"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"zellij", "setup", "--generate-completion")
  end

  test do
    assert_match("keybinds", shell_output("#{bin}/zellij setup --dump-config"))
    assert_match("zellij #{version}", shell_output("#{bin}/zellij --version"))
  end
end
