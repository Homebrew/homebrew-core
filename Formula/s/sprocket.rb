class Sprocket < Formula
  desc "Bioinformatics workflow engine built on the Workflow Description Language (WDL)"
  homepage "https://sprocket.bio"
  url "https://github.com/stjude-rust-labs/sprocket/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "056c6588558275657af0e93d1a8f8285727a7c279190c6ac6096639d994bdf0b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/stjude-rust-labs/sprocket.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0890625965bf8f5f1e08dfcc3f7279815cdc076c48b9d2a43723d88453523e16"
    sha256 cellar: :any, arm64_tahoe:       "232a8563b52070b97f1efe54d3ab07f69d4627fa6cfbd8b487dd892ddfd1ada3"
    sha256 cellar: :any, arm64_sequoia:     "da063017c8e1fa86d56ad09ca88b4c3fee03fa03e9b950abec71b56e14cc6b1d"
    sha256 cellar: :any, arm64_linux:       "c34b5d7f6624a356df0b51b7533a7ff66d81b6627dcb8aabce429ef401a95629"
    sha256 cellar: :any, x86_64_linux:      "c09e1d9062b2df91e69aaf8fa6cb224bdfde927fe49b63b8902b7eb5e8f0e2d1"
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
