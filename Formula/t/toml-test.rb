class TomlTest < Formula
  desc "Language agnostic test suite for TOML parsers"
  homepage "https://github.com/toml-lang/toml-test"
  url "https://github.com/toml-lang/toml-test/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "41d5a748b6942e535c43fc6d8a12ea7ecb6b24cb8bbe09adf929364099407741"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee578e8acafde6cec49e74d85c3f71c6116d2594e742d5f2c4be1b39ca976ad5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee578e8acafde6cec49e74d85c3f71c6116d2594e742d5f2c4be1b39ca976ad5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee578e8acafde6cec49e74d85c3f71c6116d2594e742d5f2c4be1b39ca976ad5"
    sha256 cellar: :any_skip_relocation, sonoma:        "81bbd20b442bfa5ea9bd85890a038aabddaf74db0a46b5557a9ea0ccfb25ca25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "377ad217fbdd1c3724a31cabc7dca4fdad2c662bbe0a0a017e0ffd0b02fc95a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5334df336e9c02a5f219e31fcf9e7604ad73ddf8f5874f74fddfe501fb2d9594"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/toml-test"
    pkgshare.install "tests"
  end

  test do
    system bin/"toml-test", "version"
    system bin/"toml-test", "help"

    (testpath/"stub-decoder").write <<~SH
      #!/bin/sh
      cat #{pkgshare}/tests/valid/example.json
    SH

    chmod 0755, testpath/"stub-decoder"
    system bin/"toml-test", "test", "-decoder", testpath/"stub-decoder", "-run", "valid/example*"
  end
end
