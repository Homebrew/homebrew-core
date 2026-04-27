class Sprocket < Formula
  desc "Bioinformatics workflow engine built on the Workflow Description Language (WDL)"
  homepage "https://sprocket.bio"
  url "https://github.com/stjude-rust-labs/sprocket/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "621fa4554afb69c917831184cb7162b634827edd03393c2c97ac5385e85d5515"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/stjude-rust-labs/sprocket.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d414a6d0c9441ca994e5c5cc1faefddde1ba00d965724d04440aec494468a3aa"
    sha256 cellar: :any,                 arm64_sequoia: "b5eca724b727255d9430fb8ef8a491cd895cf7df04fbd4f7f57bc1a958b55d20"
    sha256 cellar: :any,                 arm64_sonoma:  "813ba79a002f6399f33ebb3c4ca20b43061f8da0f0feee71e20a0cfca497ea06"
    sha256 cellar: :any,                 sonoma:        "777ddc80a250569a2eb12bc4d32d8f3e9389ade0c5caf030cf2931d5f5762398"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99f99bc2e785d733d7efe99bf4873da34eca79219979d6f40dbd88b2a4080e45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93488f827a6c842adbca7910ed66670f4d2bb48c401a9bd6433a89bf1dc26521"
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
