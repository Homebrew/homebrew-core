class Sprocket < Formula
  desc "Bioinformatics workflow engine built on the Workflow Description Language (WDL)"
  homepage "https://sprocket.bio"
  # pull from git tag to get submodules
  url "https://github.com/stjude-rust-labs/sprocket.git",
      tag:      "v0.20.1",
      revision: "11ded263f29d812601a730b1bf3889ac0671a327"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/stjude-rust-labs/sprocket.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7e0dc64806af55890e300f862bdddf804265030a252def69c0f6866b8362c423"
    sha256 cellar: :any,                 arm64_sequoia: "170c31bcd8787060e5570ed684234da387d6913b51b1ae539f0e97672777bacc"
    sha256 cellar: :any,                 arm64_sonoma:  "021a12347ae5703241fe9459adba8492bf223a8cf9bc1ee6b54dfb31163b6758"
    sha256 cellar: :any,                 sonoma:        "df594e88e2da0c27b40e5d7aa77d5ae462156579a19ebf7a39443b6563782601"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae0a420a0103fdcf88cc1a834f2ed4b23ca610e097723ab754affdbd2563aeea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c028ee791e2e699202081d69ca7b3959bbac5a2f2156527cace50d7f9e1bdf24"
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
