class Sprocket < Formula
  desc "Bioinformatics workflow engine built on the Workflow Description Language (WDL)"
  homepage "https://sprocket.bio"
  url "https://github.com/stjude-rust-labs/sprocket/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "8758a9a40f29c088d1f2836f483dc65af2af4457aa1c258c1d78ea75d40b22c9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/stjude-rust-labs/sprocket.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "245a357deed7dd24dcddc4669a8c420f4976d43f9000d2e7c70330c25e9567e8"
    sha256 cellar: :any, arm64_sequoia: "b7002c91e337fb56513c14abb338eacce708daa904513aa00fcc69266aad4da5"
    sha256 cellar: :any, arm64_sonoma:  "e4771f5a212ae014f0be216f1db893d12ae2e946d25cbec5d61edd6ea78f110f"
    sha256 cellar: :any, sonoma:        "081c57378ac3fd863dfba5e205949437bded85b37272422f872dae3f43045328"
    sha256 cellar: :any, arm64_linux:   "397bf5360b480e4261c7ce37b0219db9841809ba964a17f52a452ba3b30002dd"
    sha256 cellar: :any, x86_64_linux:  "3d7e3ac257daab44219463b0238b93e2f871d97841f42cfb4d0b7e539196e3f2"
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
