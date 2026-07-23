class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/refs/tags/v0.41.0.tar.gz"
  sha256 "74bf7f30b00eb857df27f5c4c93ceaaaf183089f5eff956778ea21deae3c34b4"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "122719d6cb544def0a05d2394cffec63243cae07784974a6a956b33c811e6856"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "859c9abb90dbee8a699c8ade8732d2f8cea7a0a6078037929de7c75400f92395"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c9a5a9e5b3ebb2ad86849f0e839644d91cd60a0f3f74e6328a2e74eb4acd67c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e4587759230416ff39206fa0795341a82cd362d30a24154de47325377bd0506"
    sha256 cellar: :any,                 arm64_linux:   "7b19a6b8a81931bf2634fb091240388af7fd689563f6d3d4096baf1ce76265ed"
    sha256 cellar: :any,                 x86_64_linux:  "586652dad4016ada0b4a9f657c6a3cd9b0fff103a93ed81f973e32f07f4dec7b"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"rover", "completion", shells: [:bash, :zsh])
  end

  test do
    output = shell_output("#{bin}/rover graph introspect https://graphqlzero.almansi.me/api")
    assert_match "directive @specifiedBy", output

    assert_match version.to_s, shell_output("#{bin}/rover --version")
  end
end
