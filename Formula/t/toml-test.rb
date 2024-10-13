class TomlTest < Formula
  desc "Language agnostic test suite for TOML parsers"
  homepage "https://github.com/toml-lang/toml-test"
  url "https://github.com/toml-lang/toml-test/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "e6829cdcaed94ac2bfcaea05dab9d16db0bead2d3ac9936224774a67fbd46ade"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8ded510f549bfdb671828c5a29fdd4ae9be18d24c89a1b759805a58548ce3316"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e8f84fa60cb3575cbebdbb288bfd5b1b7cc1d07b3ca7e6028c5822ab42d53757"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e8f84fa60cb3575cbebdbb288bfd5b1b7cc1d07b3ca7e6028c5822ab42d53757"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8f84fa60cb3575cbebdbb288bfd5b1b7cc1d07b3ca7e6028c5822ab42d53757"
    sha256 cellar: :any_skip_relocation, sonoma:         "a7471409f4ee3f531619b2bd63fbc770749e3b506e35ccb1d81fdcd92dc7bb87"
    sha256 cellar: :any_skip_relocation, ventura:        "a7471409f4ee3f531619b2bd63fbc770749e3b506e35ccb1d81fdcd92dc7bb87"
    sha256 cellar: :any_skip_relocation, monterey:       "a7471409f4ee3f531619b2bd63fbc770749e3b506e35ccb1d81fdcd92dc7bb87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d052b80767db257261ffbc2c39125745f20e9d155cb35441788d6e8a3046da6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/toml-test"
    pkgshare.install "tests"
  end

  test do
    system bin/"toml-test", "-version"
    system bin/"toml-test", "-help"
    (testpath/"stub-decoder").write <<~EOS
      #!/bin/sh
      cat #{pkgshare}/tests/valid/example.json
    EOS
    chmod 0755, testpath/"stub-decoder"
    system bin/"toml-test", "-testdir", pkgshare/"tests",
                            "-run", "valid/example*",
                            "--", testpath/"stub-decoder"
  end
end
