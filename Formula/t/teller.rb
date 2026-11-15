class Teller < Formula
  desc "Secrets management tool for developers"
  homepage "https://github.com/tellerops/teller"
  url "https://github.com/tellerops/teller/archive/refs/tags/v2.0.7.tar.gz"
  sha256 "1d4275ede4366a31efc94039c58da4cec87466d09cc01444c3c18e9432716d23"
  license "Apache-2.0"
  head "https://github.com/tellerops/teller.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "498a4c2d3407a60a1ca31581c9d694217d989a7d8af58f50249661ac3cbf6704"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5a9ae23fea270e5a54848ad267bbbc6333f8ae4fb7d343a6ae9d1ac693350e45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "87cf330481da777449b02b7ec37182b9c51544d0bf99eb93baeecde764647d6e"
    sha256 cellar: :any,                 arm64_linux:       "55426859c6e808915e5e3ffbfdc56cd770bba8b0ccc18f6dad1bf8d750d15222"
    sha256 cellar: :any,                 x86_64_linux:      "8eb9ccbb9a46d6c14abb7fcc087a8dec282cabd4fe44de99d6c98d3a7f8b6193"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    # Update to openssl 0.10.78 and openssl-sys 0.9.114 for minimum needed to use OpenSSL 4.
    # Using `cargo update` rather than patch to work with stable and head.
    if build.stable?
      openssl_sys_version = File.read("Cargo.lock")[/name = "openssl-sys"\nversion = "(\d+(?:\.\d+)+)/i, 1]
      odie "Remove `cargo update` workaround!" if Version.new("0.9.114") <= openssl_sys_version
    end
    system "cargo", "update", "openssl-sys", "--precise", "0.9.114"
    system "cargo", "update", "openssl", "--precise", "0.10.78"

    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "teller-cli")
  end

  test do
    (testpath/"test.env").write <<~EOS
      foo=bar
    EOS

    (testpath/".teller.yml").write <<~YAML
      project: brewtest
      providers:
        # this will fuse vars with the below .env file
        # use if you'd like to grab secrets from outside of the project tree
        dotenv:
          kind: dotenv
          maps:
          - id: one
            path: #{testpath}/test.env
    YAML

    output = shell_output("#{bin}/teller -c #{testpath}/.teller.yml show 2>&1")
    assert_match "[dotenv (dotenv)]: foo = ba", output

    assert_match version.to_s, shell_output("#{bin}/teller --version")
  end
end
