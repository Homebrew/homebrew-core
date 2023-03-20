class TomlTest < Formula
  desc "Language agnostic test suite for TOML parsers"
  homepage "https://github.com/burntsushi/toml-test"
  url "https://github.com/BurntSushi/toml-test/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "737604b374669975fd8d80c562124e2ff4913217aeadbb14ff07033c52fe09ac"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "591bf561dfdaaf206b5b622853f2520effd025ef36e5b35046863cca6a56bcb2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "591bf561dfdaaf206b5b622853f2520effd025ef36e5b35046863cca6a56bcb2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "591bf561dfdaaf206b5b622853f2520effd025ef36e5b35046863cca6a56bcb2"
    sha256 cellar: :any_skip_relocation, ventura:        "33c6ade25312fa354e0bf9ba1f754644904cae6e2eb9c5793517ef92ab683c46"
    sha256 cellar: :any_skip_relocation, monterey:       "33c6ade25312fa354e0bf9ba1f754644904cae6e2eb9c5793517ef92ab683c46"
    sha256 cellar: :any_skip_relocation, big_sur:        "33c6ade25312fa354e0bf9ba1f754644904cae6e2eb9c5793517ef92ab683c46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4ed2940fb820d865bc210919fbb8e105a369dbf164cac5f6caf3fea89cc330f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/toml-test"
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
