class Sprocket < Formula
  desc "Bioinformatics workflow engine built on the Workflow Description Language (WDL)"
  homepage "https://sprocket.bio"
  url "https://github.com/stjude-rust-labs/sprocket/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "2600daf8e240028044e66312c0950efd7bab49b929b3e437643bd2c8d6240de2"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/stjude-rust-labs/sprocket.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2cfc3f5182eff728332feeaff79b0e60841eba0284561691b2f408441cef51c0"
    sha256 cellar: :any,                 arm64_sequoia: "ad46bdd387a1c962ac5d58c0929f844d8efb92e7e56e210d6341ca293e7eeed9"
    sha256 cellar: :any,                 arm64_sonoma:  "c1173f59b7bb8cb2ae6454dd8492779085ac3cffd07c92d5048421f904aa41c9"
    sha256 cellar: :any,                 sonoma:        "c0fd1832d13464b697ee3fa91e9d90a25de55ec0e063c1bf59213744b0fc1091"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "831c4418597a19f005c26a751945b912c87bc5372baf01b073b63cbaabe3a9ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88cce00dc5b81643e6a32b73edfc537c0dbef5c4b5621eb55cc9ed4b96f51f0d"
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
