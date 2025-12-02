class Sprocket < Formula
  desc "Bioinformatics workflow engine built on the Workflow Description Language (WDL)"
  homepage "https://sprocket.bio"
  # pull from git tag to get submodules
  url "https://github.com/stjude-rust-labs/sprocket.git",
      tag:      "v0.19.0",
      revision: "9b96d4f62e08c32bd4ba607fa2ce356a4748408a"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/stjude-rust-labs/sprocket.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6f3bc4b2da43f700dde84628949ba1bf80e51d061fd11b8e9faf510b6d15fd03"
    sha256 cellar: :any,                 arm64_sequoia: "ecec9312863b3a93b683b59785eaf5fd16fa50cd14623c09db06afb357c4ede7"
    sha256 cellar: :any,                 arm64_sonoma:  "d3b04b0e1f11a9b3c9b49e0facfde8235ea5baa0dd59f6af36958d7d86ad69bf"
    sha256 cellar: :any,                 sonoma:        "1342f28157a7991ba1a508a4996d8ce68c0b7ccc1e22fef8e64d0ac6c7129e81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d4577d496666cff0468ca0353a99f531dce5b4821f1b1c8add75c7bf228e924"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ed50f47b1b7b9030d1af1a1fe0b4b58636c4c8ccac5a4becec2131036c74da2"
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
        "say_hello.greeting": "String <REQUIRED>",
        "say_hello.name": "String <REQUIRED>"
      }
    JSON

    assert_match expected, shell_output("#{bin}/sprocket inputs --name say_hello #{testpath}/hello.wdl")
  end
end
