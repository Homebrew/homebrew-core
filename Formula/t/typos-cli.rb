class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.52.0.tar.gz"
  sha256 "5c4e27cb8ef43e7ebf8151a671f2db4888b53872641bdd6a66ec20de7397de14"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "179f4dbb9068eb7b180277bfd3169bcdb80aaae5012e05b5744f63d3f333bd02"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c8418fa6fa3071bd571b39961c238c069d6883afe68bf2c304b081f1de3f0e57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "349d887b045d7d7869856da6c10f31d5aca3755b377cfcfa5de701dc37d40069"
    sha256 cellar: :any,                 arm64_linux:       "c1f5fc726dbb355239af0f78b4449031fad6a5981e225bb929188b1dea040b9f"
    sha256 cellar: :any,                 x86_64_linux:      "9dfb0267cc67043f750d77828d923d6a33a722501e8108032270c5fabf5b2b23"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/typos-cli")
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}/typos -", "teh", 2)
    assert_empty pipe_output("#{bin}/typos -", "the")
  end
end
