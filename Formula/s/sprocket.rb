class Sprocket < Formula
  desc "Bioinformatics workflow engine built on the Workflow Description Language (WDL)"
  homepage "https://sprocket.bio"
  url "https://github.com/stjude-rust-labs/sprocket/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "71e61ebc2aa03253c1a1836721ab3afe4b14563b215de8a8fa2fdf20548fe4fe"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/stjude-rust-labs/sprocket.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "26fc6de346fd9cd7d95928b0186f392fca4ab10dcb2bd13f385978b5ebe57a62"
    sha256 cellar: :any, arm64_tahoe:       "04bf43c6de0cee0485abdfd6e9125f5cb6d810dad27b0d7a30ac4f4f478a2345"
    sha256 cellar: :any, arm64_sequoia:     "4b72eb7fe673cdeef858d7f54f3ff705415ee72de861db50aaf8b08b1e3f860f"
    sha256 cellar: :any, arm64_linux:       "409e9de50b46fa1a856760610a0e08bfcf8788455b61dd3cbc165c1b9193f120"
    sha256 cellar: :any, x86_64_linux:      "93471fa2c64fa3995613d4b7d0908c36c2ed31cb0af44cd5a87bcd09545b7c94"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
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
