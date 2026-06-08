class SarifFmt < Formula
  desc "Pretty print SARIF files to easy human readable output"
  homepage "https://docs.rs/crate/sarif-fmt/latest"
  url "https://github.com/psastras/sarif-rs/archive/refs/tags/sarif-fmt-v0.8.0.tar.gz"
  sha256 "5182811d6ce671b9443fc6032028612fe0f60e8c37b177710e3edba0d7d2db88"
  license "MIT"
  head "https://github.com/psastras/sarif-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^sarif-fmt[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "082dcb6c6de6d371b362f9e59bdcc672f211be143b81bb5a59e4bae020eba4cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edc1f6bff6d9bf0921ce1480207c7a5a66cf35fd694565338d463a33c9e138f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "768c9041d5073662247a5ef5301484ec0dcf1063a95a5f96aa5e9d586f0199e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "9aeab703f9e6dddcda32538295d1b0fc9c0c7813b0e789a9ef72ad1eb0fc0460"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a0f052f8cd78fc71c33d70546dec05a22df96596d51688b5bf4d587474b571a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa79b3709106c0654578c1399165788b15c10e9fa97ea626355367ae7c343a3d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "sarif-fmt")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sarif-fmt --version")

    (testpath/"test.cpp").write <<~CPP
      #include <stdlib.h>

      int string_to_int(const char *num) {
        return atoi(num);
      }
    CPP

    (testpath/"test.sarif").write <<~EOS
      {
        "runs": [
          {
            "results": [
              {
                "level": "warning",
                "locations": [
                  {
                    "physicalLocation": {
                      "artifactLocation": {
                        "uri": "test.cpp"
                      },
                      "region": {
                        "startColumn": 10,
                        "startLine": 4
                      }
                    }
                  }
                ],
                "message": {
                  "text": "'atoi' used to convert a string to an integer value, but function will not report conversion errors; consider using 'strtol' instead [cert-err34-c]"
                }
              }
            ],
            "tool": {
              "driver": {
                "name": "clang-tidy"
              }
            }
          }
        ],
        "version": "2.1.0"
      }
    EOS

    output = shell_output("#{bin}/sarif-fmt -i test.sarif")
    assert_match "warning: 'atoi' used to convert a string to an integer value", output
  end
end
