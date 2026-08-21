class Sprocket < Formula
  desc "Bioinformatics workflow engine built on the Workflow Description Language (WDL)"
  homepage "https://sprocket.bio"
  url "https://github.com/stjude-rust-labs/sprocket/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "e3fc518640fff8b59ee59ebaeef514f1f8d1ff6c6004f54910b5b5541178a94f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/stjude-rust-labs/sprocket.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "26de8d3a0c8d1b0d79fcf1a24b0f762683123fe4aded3d89473d13a67ff786fd"
    sha256 cellar: :any, arm64_sequoia: "31a4b32ecd922f165695423a29d252ed97ec2988ca5312d369e4347b407a8043"
    sha256 cellar: :any, arm64_sonoma:  "675c6407bc58131f4f76dda033062b6242ef4e81c7979274be37bf494cad77df"
    sha256 cellar: :any, sonoma:        "7533d3c097ede54dd5f5e567b2d054efde76b946e448c6d5252551800c438957"
    sha256 cellar: :any, arm64_linux:   "b9147dce111649fec260e5fb8a51a2e4f2c68fb22ad49cdc4e813e2d9ad478a0"
    sha256 cellar: :any, x86_64_linux:  "6711351a9120da6255cc33ba9958895c922e2c2df62bc7d08d9011ba746a5784"
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
