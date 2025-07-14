class Sprocket < Formula
  desc "Bioinformatics workflow engine built on the Workflow Description Language (WDL)"
  homepage "https://sprocket.bio"
  url "https://github.com/stjude-rust-labs/sprocket/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "8c68d5d1fc789734df08b398852e7178c20413d62a602d233d4022d6521bd153"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/stjude-rust-labs/sprocket.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "530168aed77c247727c34728972d69c819604480a19ebe8cb6593536bc40df7f"
    sha256 cellar: :any,                 arm64_sonoma:  "b81af44813a3cabf7304397194df9b7e7df81a07819550e4be6d0853608eda82"
    sha256 cellar: :any,                 arm64_ventura: "3be5c856d70f0baf63b5d5caf714a86f94dbb4e798f07ce6f4d207476c6d789d"
    sha256 cellar: :any,                 sonoma:        "53b877a09c092d747f8aa4e65f34388fd69da5d8914edb8f356e3e1bb7ab5687"
    sha256 cellar: :any,                 ventura:       "bd71b5e65705f0b95ae9f2b5d5d17b370ef97f4e07d545642912c59fae3fc583"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cdd5a8ca51fde4d4fbcb72f9592d676bec5a476b4946a651d9ef1d203b6b114b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "068899014aece2cc8b386f16a4a85aa83139bae6eee63ea8976ebf5b470cfd6f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
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

    expected = <<~JSON.strip
      {
        "say_hello.greeting": "String",
        "say_hello.name": "String"
      }
    JSON

    assert_match expected, shell_output("#{bin}/sprocket inputs --name say_hello #{testpath}/hello.wdl")
  end
end
