class Sprocket < Formula
  desc "Bioinformatics workflow engine built on the Workflow Description Language (WDL)"
  homepage "https://sprocket.bio"
  # pull from git tag to get submodules
  url "https://github.com/stjude-rust-labs/sprocket.git",
      tag:      "v0.22.0",
      revision: "d022d74d39cb8c3e537d99e0dd4980c75a2e6a99"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/stjude-rust-labs/sprocket.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6f8ea3990cf53b3addd7c304ac7935603d55851fc002e472d59d6bced9eaa6ae"
    sha256 cellar: :any,                 arm64_sequoia: "596da87c69cdf235ed1607e4b94f321435d2893cf90b0c74e80235016a448159"
    sha256 cellar: :any,                 arm64_sonoma:  "b03bf20a3605a350ddcb29185ee4c54252d76ca619ff2ef7231024e6c80ad1cf"
    sha256 cellar: :any,                 sonoma:        "14b5a2e82c8a11d53af09ac4bb3f3d426a65199253176fadf6a973aa35109f3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c0dfdc77b2e5e2865c61e2b3fedee4d44ebcac5f5b62671fa510901c96e1b26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd49695e9e892c036a5700639b762f95a5d23053e437fdbacbc9365e7d7fe53c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
