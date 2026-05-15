class Sprocket < Formula
  desc "Bioinformatics workflow engine built on the Workflow Description Language (WDL)"
  homepage "https://sprocket.bio"
  url "https://github.com/stjude-rust-labs/sprocket/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "ef579ecf75a09012ff0c8724c2028c5da33c2825cec62064cb7b0afffc1dfbb3"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/stjude-rust-labs/sprocket.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ae63d5516598b3c16f579fc359f55f907520db00e3ebbf990e1fcaf9ddfb828c"
    sha256 cellar: :any,                 arm64_sequoia: "b5a33acc4e779ec529c709ecec71c2e360650b9f219903805dbddda6c1945b23"
    sha256 cellar: :any,                 arm64_sonoma:  "366fc59cd4bb9c230f012ed3d715edf4750b7a3d19c9667b7351f66bc893d7b7"
    sha256 cellar: :any,                 sonoma:        "21da281a0ad72c610eb0095f65ab63a660985d82468328cba9b6b3c67db93d30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d03d13b239afed9a341734d8fae23577d4d159efdb80e18b1de6b5c5a435a0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4983d0922e2baab425442340fecba207aaf2fcb03ceb3f65d79ac3fe3ba4d3a"
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
