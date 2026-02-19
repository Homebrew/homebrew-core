class Sprocket < Formula
  desc "Bioinformatics workflow engine built on the Workflow Description Language (WDL)"
  homepage "https://sprocket.bio"
  # pull from git tag to get submodules
  url "https://github.com/stjude-rust-labs/sprocket.git",
      tag:      "v0.21.1",
      revision: "16a97e58197031d3c07112192f23efceb7f036de"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/stjude-rust-labs/sprocket.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "cc05b7859da33e6ed068be803480085b6334279b8ed9eb9972c25a35932b2972"
    sha256 cellar: :any,                 arm64_sequoia: "23640359ec0c0522a9390f5709fa5b8dc5f4a9f57db1130e384679e5e7efd6bb"
    sha256 cellar: :any,                 arm64_sonoma:  "df24e6ef0aecec1ab5bb96069d3fcd5def8b91e687f466c29aac9555b52c713d"
    sha256 cellar: :any,                 sonoma:        "befe3493c616e91c7c54a3d946dad1ec3f5ebc5842c1362943fed6b1222693a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e13387d2fc9ae0c08c14f09647f4ace87c9e0a039ee2e76df3af8bf7d9dfeb37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4871f18839c5588d3931555870e2f41ee80f3495bcfde98e7eadcf5ed03b006c"
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
