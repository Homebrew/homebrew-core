class Shadowenv < Formula
  desc "Reversible directory-local environment variable manipulations"
  homepage "https://shopify.github.io/shadowenv/"
  url "https://github.com/Shopify/shadowenv/archive/refs/tags/3.6.0.tar.gz"
  sha256 "08e417e238c684f86020b931fc757aa134099db6215fc581911771bfad254f82"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d5c80c57acb4d28166bc036c8329f3d312871e54995ceb6d1e8b7afdbe30d66e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f71d7e9cd0dc75069a4ddbf5da18c9ff40ec0a6cd6aee9689961b69bd8abdadd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "af825b16bfd0f74c3657963dd9bb8ccef7102e9a33ba5a18a96a2e79b53383b3"
    sha256 cellar: :any,                 arm64_linux:       "04d38383a94e29ee45cced67d7ca1f79cd0114277d0364611dbc41d5a7223f56"
    sha256 cellar: :any,                 x86_64_linux:      "56e62096a6110ddca49ddc225dcfce14afd65e8cb8946e7accb144124048fb16"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "#{buildpath}/man/man1/shadowenv.1"
    man5.install "#{buildpath}/man/man5/shadowlisp.5"
  end

  test do
    expected_output = <<~EOM
      EXAMPLE:
      EXAMPLE2:b
      EXAMPLE3:b
      EXAMPLE_PATH:a:b:d
      ---
      EXAMPLE:a
      EXAMPLE2:
      EXAMPLE3:a
      EXAMPLE_PATH:c:d
    EOM
    environment = "export EXAMPLE2=b EXAMPLE3=b EXAMPLE_PATH=a:b:d;"
    hash = "1256a7c3de15e864"
    data = {
      "scalars" => [
        { "name" => "EXAMPLE2", "original" => nil, "current" => "b" },
        { "name" => "EXAMPLE", "original" => "a", "current" => nil },
        { "name" => "EXAMPLE3", "original" => "a", "current" => "b" },
      ],
      "lists"   => [
        { "name" => "EXAMPLE_PATH", "additions" => ["b", "a"], "deletions" => ["c"] },
      ],
    }
    # Read ...'\"'\"'... on the next line as a ruby `...' + "'" + '...` but for bash
    shadowenv_cmd = "export __shadowenv_data='\"'\"'#{hash}:#{data.to_json}'\"'\"'; #{bin}/shadowenv hook"
    print_vars =
      "echo EXAMPLE:$EXAMPLE; echo EXAMPLE2:$EXAMPLE2; echo EXAMPLE3:$EXAMPLE3; echo EXAMPLE_PATH:$EXAMPLE_PATH;"

    assert_equal expected_output,
      shell_output("bash -c '#{environment} #{print_vars} echo ---; eval \"$(#{shadowenv_cmd})\"; #{print_vars}'")
  end
end
