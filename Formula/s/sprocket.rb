class Sprocket < Formula
  desc "Bioinformatics workflow engine built on the Workflow Description Language (WDL)"
  homepage "https://sprocket.bio"
  url "https://github.com/stjude-rust-labs/sprocket/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "cf72f8d4930ce16ae3adc73f82c9ed82aceb8f09330e5f78658a88e0b5d99986"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/stjude-rust-labs/sprocket.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "900f29532e238df4be8d3b87b4c6be773df42df2027aaa38bc0bc685831442ce"
    sha256 cellar: :any,                 arm64_sequoia: "5ee7d0e3d30fe78fd7a6cf97940710ab23e6d8e2cbb945fb70f01aef88ce9717"
    sha256 cellar: :any,                 arm64_sonoma:  "4a2ec2fa95e2bd0196435e40541b4800bf8258dee998637929b621201d09f795"
    sha256 cellar: :any,                 sonoma:        "fa4ce7cd37fac0a61e0fe2c45d506101e1681264b8b16eba30be67a187363f79"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7929b4f8f95be452937e95c2ac58774beebd06464cab42aad772360fdcbecd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b60cea4c2d9916e741fdfd6b573edffe06721340f39485a242ffdbee42e3be1b"
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
        "say_hello.greeting": "String",
        "say_hello.name": "String"
      }
    JSON

    assert_match expected, shell_output("#{bin}/sprocket inputs --name say_hello #{testpath}/hello.wdl")
  end
end
