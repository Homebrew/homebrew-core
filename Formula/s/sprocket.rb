class Sprocket < Formula
  desc "Bioinformatics workflow engine built on the Workflow Description Language (WDL)"
  homepage "https://sprocket.bio"
  url "https://github.com/stjude-rust-labs/sprocket/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "ae43ed76b0b1fc85b3804ff4d3f95fcee1eb32e1f72c32f0e971d89532c307eb"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/stjude-rust-labs/sprocket.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4674d4e6f760ac6b2cf9fbbf5a931c479056a459326619252a544ac8ea2bc8e4"
    sha256 cellar: :any, arm64_tahoe:       "4b6541117ea70fde784a85c22068182c8b790951219b97b047e6109ec3454abe"
    sha256 cellar: :any, arm64_sequoia:     "cf10f044eceba627c723ac624bb8fc241090fe25bd8b5e1d44c1e032318afcf8"
    sha256 cellar: :any, arm64_linux:       "ee19f498063e221eee5006a99026d0040233ae177893416a3b62c634c17a55dc"
    sha256 cellar: :any, x86_64_linux:      "cd8a1997ec7a973095092b396597cc7e2e536cd7d326901b862f19e235531e89"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"sprocket", "completions", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sprocket --version")

    (testpath/"hello.wdl").write <<~WDL
      version 1.2

      task say_hello {
        input {
          String greeting
          String name
        }

        command <<<
          echo "~{greeting}, ~{name}!"
        >>>

        output {
          String message = read_string(stdout())
        }

        runtime {
          container: "ubuntu:latest"
        }
      }
    WDL

    output = shell_output("#{bin}/sprocket inputs --target say_hello #{testpath}/hello.wdl")
    assert_match <<~JSON.strip, output
      {
        "say_hello.greeting": "String <REQUIRED>",
        "say_hello.name": "String <REQUIRED>"
      }
    JSON
  end
end
