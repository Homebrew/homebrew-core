class Shadowenv < Formula
  desc "Reversible directory-local environment variable manipulations"
  homepage "https://shopify.github.io/shadowenv/"
  url "https://github.com/Shopify/shadowenv/archive/2.0.4.tar.gz"
  sha256 "c878b343b4cbe40b1ec4d6dd553a84b250be3b454205ad78e7a33fb8478cfc48"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "947718ba627c934ec597e9e5d6f8eb12e7205e41cd0e51d7bc1745cb5bd24d40"
    sha256 cellar: :any_skip_relocation, big_sur:       "fc41f2d973d0d6b18b490af91cdd51a71986c6f5901892b69363d1aeb4743d3c"
    sha256 cellar: :any_skip_relocation, catalina:      "3818f557a4d4401dd5eb09177621724e48914f6cbb51d2e92ace1e7d891668c3"
    sha256 cellar: :any_skip_relocation, mojave:        "489a6fb71afd4932813c6c376cbc6862b14dea2f1b8984b6b161bd55633dfc07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "638e11b45fbb408a378eb3f064b72c8229be379584062ff02770933656f351f0"
  end

  depends_on "rust" => :build

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
    shadowenv_command = "#{bin}/shadowenv hook '\"'\"'#{hash}:#{data.to_json}'\"'\"' 2> /dev/null"
    print_vars =
      "echo EXAMPLE:$EXAMPLE; echo EXAMPLE2:$EXAMPLE2; echo EXAMPLE3:$EXAMPLE3; echo EXAMPLE_PATH:$EXAMPLE_PATH;"

    assert_equal expected_output,
      shell_output("bash -c '#{environment} #{print_vars} echo ---; eval \"$(#{shadowenv_command})\"; #{print_vars}'")
  end
end
