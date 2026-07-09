class Sprocket < Formula
  desc "Bioinformatics workflow engine built on the Workflow Description Language (WDL)"
  homepage "https://sprocket.bio"
  url "https://github.com/stjude-rust-labs/sprocket/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "88bbbe975f2b69edc22c4bfe8055e6e113e866951d369201be4972acff989bfc"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/stjude-rust-labs/sprocket.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "851867254e9d720950c39f18feb4882e8ebfa7ec5ba474dc0ee66af2dea964f1"
    sha256 cellar: :any, arm64_sequoia: "0116a04ee2bc645f7335b4e9c2540836a106468fc1198f4a760e71379fe23e3b"
    sha256 cellar: :any, arm64_sonoma:  "726158362c4e78d0a6119f41b1eb238041155045879efd69c409ae7c1837b60e"
    sha256 cellar: :any, sonoma:        "14ed41b56adc8c557d87bafec77f64a246098c083cd8a34e19e269bbe8bb0c1f"
    sha256 cellar: :any, arm64_linux:   "b08dca3b3a2474494b24682860436e0d7b77b75428e31c375d99c94dd15e297c"
    sha256 cellar: :any, x86_64_linux:  "8696806b8c7ef0bd7c4a7f350e88ef5d08501590fda133a9d92decdb66d0b92b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

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
