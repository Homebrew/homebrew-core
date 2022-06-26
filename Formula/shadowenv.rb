class Shadowenv < Formula
  desc "Reversible directory-local environment variable manipulations"
  homepage "https://shopify.github.io/shadowenv/"
  url "https://github.com/Shopify/shadowenv/archive/2.0.7.tar.gz"
  sha256 "9e0605f2d6928d1db59e2b86b8767a115bd9ea7bba940c028372b87d3d049bac"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c62d2644c0b630b3f81b9a90f51e8d475b36e2b672b3a15cf2a0c74973957b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c9eb11724211644dcae5a3ad1c91629a0cb47c246462963ebb5db54096794aa5"
    sha256 cellar: :any_skip_relocation, monterey:       "bfd00b77c99d40605bc870a75eadd5fcc9d24ec2732fc97bd424b3330e85be09"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0abbc0c7091d3c7c8c8a848ef1527f1dd56d1b7cf46d754f031517ae2bb0ad1"
    sha256 cellar: :any_skip_relocation, catalina:       "df4baa0222779ba882fb80b8ec4dda6e919d1389081ca2da86a652a3faa5996c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fdea6198dcbd4f65c141604a906bcba148fcfd1589abc5b6b032c27513d6207"
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
