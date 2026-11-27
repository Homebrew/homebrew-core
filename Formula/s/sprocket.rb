class Sprocket < Formula
  desc "Bioinformatics workflow engine built on the Workflow Description Language (WDL)"
  homepage "https://sprocket.bio"
  url "https://github.com/stjude-rust-labs/sprocket/archive/refs/tags/v0.34.1.tar.gz"
  sha256 "e5d13afcf1beb48cc8c5947ca35b02849c3cdd940490f3f936887fb54c026056"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/stjude-rust-labs/sprocket.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "1024b8f334799ced8da615818765174e0ce667d8a7892f1c51ce24df0ea40d41"
    sha256 cellar: :any, arm64_golden_gate: "d181109ef4a9d65692031c2ad1a030687d9701dbdfded91d995a7bd37fa68640"
    sha256 cellar: :any, arm64_tahoe:       "f3c655ca00767ed7425996a1b911a4afd980b320bd13bf3c58259c3dbc7153fd"
    sha256 cellar: :any, arm64_sequoia:     "2be6c670b9101c89b95abd5d3a8f7dffd1b5a65f1c08de2054aa69bb44d7446d"
    sha256 cellar: :any, arm64_linux:       "78c28bbbc76e2359dbf002ccfa93b790a505c0b323ce4d6b990bb4cb9be09b0b"
    sha256 cellar: :any, x86_64_linux:      "3ea3789ab8a735a6c16e254857de9c8230a0b29995c1ad1ef97b10791be26b71"
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
