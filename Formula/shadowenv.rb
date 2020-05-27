class Shadowenv < Formula
  desc "Reversible directory-local environment variable manipulations"
  homepage "https://shopify.github.io/shadowenv/"
  url "https://github.com/Shopify/shadowenv/archive/2.0.2.tar.gz"
  sha256 "cd84eae312073b7ff3d799b9f095d16c8d97edc4700a2af0c359a1db744714e6"

  bottle do
    cellar :any_skip_relocation
    sha256 "8392eac6bf8d09067b6688d6bc713d6ef36bbdf16111253f6da7f355164a6e24" => :catalina
    sha256 "65aa5ddb76b7ebb453f4aa138847d237616d5c36a41376e5349bb9b87e5f656c" => :mojave
    sha256 "000b9f2d6fb73be7d466fce5cf948eeba3df27261bc410f6d0064cd3a4d09e92" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
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
