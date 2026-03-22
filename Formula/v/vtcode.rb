class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.92.0.crate"
  sha256 "1749fcb31fe59d40fe840e19b94a9da1971a0e735e5d47753afe2b041cd20330"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "96236aa448a561c08a302419f5f4797e4bfcfd247c30572572ba86ca61d34826"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c68ad878694d1d4b6bc50ad828279c823912bc55433544f18e4b1fa911c83d81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc2f273c3995fc93ce5d929271ba5642aa445d15e70103e9a78e355446d5a3e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "82102f1d8ff7b07d0a32e906f09057352010faca4a6a06bb81202dfc4cf8ea9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1eec6e18d95103b4e6b4f82e7fb952dca7e8ab7569eba074feb600b7cddc0d60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6354ce542a06364a39ebd185ed456bf745a089d487935d75a319c708b5f2d48d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    ENV["OPENAI_API_KEY"] = "test"
    output = shell_output("#{bin}/vtcode models list --provider openai")
    assert_match "gpt-5", output
  end
end
