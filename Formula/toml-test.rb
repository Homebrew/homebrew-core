class TomlTest < Formula
  desc "Language agnostic test suite for TOML parsers"
  homepage "https://github.com/burntsushi/toml-test"
  url "https://github.com/BurntSushi/toml-test/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "33bf4e9c017cd57f3602e72d17f75fb5a7bcc7942541c84f1d98b74c12499846"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e71607b7f86a9d2055b35cd0dedfaad9ec9798e6ac14312fa15f4647d38666d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8723308819ae761f36a57f08dd87650412f500dd51d7901043dcd42e3b4630bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8723308819ae761f36a57f08dd87650412f500dd51d7901043dcd42e3b4630bb"
    sha256 cellar: :any_skip_relocation, ventura:        "762595a2b728efaf685ae5b0d9927bb4d91b40f82452cd91bee8f1dd79c7918c"
    sha256 cellar: :any_skip_relocation, monterey:       "0ae0985c6f7468629a0054689638504600ef391dca08651033cbacf9ec940135"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ae0985c6f7468629a0054689638504600ef391dca08651033cbacf9ec940135"
    sha256 cellar: :any_skip_relocation, catalina:       "0ae0985c6f7468629a0054689638504600ef391dca08651033cbacf9ec940135"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a579f93ab28c4aef05c70203fdabe73742f337a5d230615fc9c908aaa0a98d7a"
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
