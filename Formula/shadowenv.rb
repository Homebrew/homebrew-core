class Shadowenv < Formula
  desc "Reversible directory-local environment variable manipulations"
  homepage "https://shopify.github.io/shadowenv/"
  url "https://github.com/Shopify/shadowenv/archive/2.0.6.tar.gz"
  sha256 "53b8cb45db599596d07fe5eada7411d71ceb75c6e4ca22ae33b7196720eece42"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a01d1e377253ea11db6462644f7c3bf88c4476f292e7909f24806ae504100a95"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e1385722a4196c36cac9be0f24f41a134031ec800caf336cb52d29beccd1777e"
    sha256 cellar: :any_skip_relocation, monterey:       "c94361529245e287adcc3edfce02c916ec242660c308b760b7f299156a6ce6f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "0aa59a919ee173a4f52a792cf8efac267df60233fcd5ea48ea89749dad43f350"
    sha256 cellar: :any_skip_relocation, catalina:       "a61f75e84322bc9554691f540a53c51042034163d85328c6f1eb78cb4cb0cfd6"
    sha256 cellar: :any_skip_relocation, mojave:         "cbbfa9a3b1a4850cf12f8f025533edb6c142ed68e75f201061773d0cd6006750"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17d6affcde8f58c00eabf2bcab526b9b7c54f5a141c68a9e2101cfd6fd7a1b7a"
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
