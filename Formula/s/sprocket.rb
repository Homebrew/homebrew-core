class Sprocket < Formula
  desc "Bioinformatics workflow engine built on the Workflow Description Language (WDL)"
  homepage "https://sprocket.bio"
  # pull from git tag to get submodules
  url "https://github.com/stjude-rust-labs/sprocket.git",
      tag:      "v0.18.0",
      revision: "3f19960e232ac96af539ab8aeda7a8101832d213"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/stjude-rust-labs/sprocket.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a918c88d1763c710a25b4f8c5f1948d8e3ef2a691fc0648d34bdb2985aa62f6f"
    sha256 cellar: :any,                 arm64_sequoia: "c5e4197d5538054f53c52d913b76279418b17f4fb9d21eaa3df0f2a5f2185208"
    sha256 cellar: :any,                 arm64_sonoma:  "c54e8c7d944f5bdc3629e9570514683671f643e03c56c0278b1f9a091a4ff6d0"
    sha256 cellar: :any,                 sonoma:        "716ad267bcb384d7426b5400da2aeff12248d2f14058a33acf607641104262da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5cd2e170f6047a11b389b3fad33d2678b35909e6bb9271221bb1440f5cc62d3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5f9aa2bb7563e48898cb0562e5b03909dceb53d0dbec30419af68ce81603cb4"
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
