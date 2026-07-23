class Shadowenv < Formula
  desc "Reversible directory-local environment variable manipulations"
  homepage "https://shopify.github.io/shadowenv/"
  url "https://github.com/Shopify/shadowenv/archive/refs/tags/3.5.1.tar.gz"
  sha256 "ff81d1baa7567b7570bb1e842d6a248f2f7c42c56bfa5f4c76beeb450395017c"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3249a38740fd5a0d86466569ae6bb112e7cf33be9ed553ba728937337e2d742d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26e31341f5d5023a2ffc9ec25e6e08fe53b8dea5a7822b25881b42b5cbd44a82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3611e4dbe9a590b7a0ee5c3c6e3dd2f46cb8177417acc79b9cfb1bfdaad6e9bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d8e07f166044a89d0d10282a8df1f3e8a926aa3abf41efae5700225140bb6d2"
    sha256 cellar: :any,                 arm64_linux:   "51b269791e43051c2675fcb64c97637184ed73314998c0bb5460c3c728833a42"
    sha256 cellar: :any,                 x86_64_linux:  "adad6f9d4834fc070de3414c1970516b52f954bf1ef28c352daa54c4954cb5a1"
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
    shadowenv_cmd = "export __shadowenv_data='\"'\"'#{hash}:#{data.to_json}'\"'\"'; #{bin}/shadowenv hook"
    print_vars =
      "echo EXAMPLE:$EXAMPLE; echo EXAMPLE2:$EXAMPLE2; echo EXAMPLE3:$EXAMPLE3; echo EXAMPLE_PATH:$EXAMPLE_PATH;"

    assert_equal expected_output,
      shell_output("bash -c '#{environment} #{print_vars} echo ---; eval \"$(#{shadowenv_cmd})\"; #{print_vars}'")
  end
end
