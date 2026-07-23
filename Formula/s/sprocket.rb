class Sprocket < Formula
  desc "Bioinformatics workflow engine built on the Workflow Description Language (WDL)"
  homepage "https://sprocket.bio"
  url "https://github.com/stjude-rust-labs/sprocket/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "481b721683dafca2214f0663e4a614d6fb5171c65bf10bff42c8a06fb4f5cf21"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/stjude-rust-labs/sprocket.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2c70b9f6e99df56b43af01332c80ee8996eeaf9cc0bf38784eee5f88f7a834f4"
    sha256 cellar: :any, arm64_sequoia: "aeba978ec90911584d4a5f270c938f42a979492085a455d282cecf5d67f014ac"
    sha256 cellar: :any, arm64_sonoma:  "105164d9db1f9f26407c2a8893a5eca762c534731114fc446efc4e08aff8cc52"
    sha256 cellar: :any, sonoma:        "1a6ca7aadc1840f02ab24182af8526c1f86ab19b130b17a6dfc9c607804c8e20"
    sha256 cellar: :any, arm64_linux:   "27470556319d533a2aa57a94b069dee9b969902ad487e1b9289d351e39627967"
    sha256 cellar: :any, x86_64_linux:  "48ffb4e6e54ac913ce386da424cae8fac20dda06b99ad202a31c066a367dff50"
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
