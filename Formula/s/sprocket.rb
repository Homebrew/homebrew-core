class Sprocket < Formula
  desc "Bioinformatics workflow engine built on the Workflow Description Language (WDL)"
  homepage "https://sprocket.bio"
  url "https://github.com/stjude-rust-labs/sprocket/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "4830760175de4ccc402fdb11b3763b1864db63b71828039ce76b422cc03019a0"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/stjude-rust-labs/sprocket.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2aff46ba9cca6ae2a43840eb559187d756b0aebd3932cd501130c4b0f6424c09"
    sha256 cellar: :any,                 arm64_sequoia: "cae5f4b72ede7258ad20783343096e86a6aa0e98b85e652d448ae0c117b63090"
    sha256 cellar: :any,                 arm64_sonoma:  "9c5ffb386e2f7e559ee76964c14b2c27502a58ce76f3e111a870adc64ed286a8"
    sha256 cellar: :any,                 sonoma:        "b44d83f66883b0b2d5489dbc72a4159b16f7bc4f889442c8825da744e45bd605"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47583230186fe5197e2fb5bcb21d2773cf716246f6829081598c2f6ba13ae678"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "760614e7f7cb8030b17578b525649e9250cbe9d6d4903fed3137e01afb0bd616"
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
