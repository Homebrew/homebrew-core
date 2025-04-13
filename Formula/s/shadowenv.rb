class Shadowenv < Formula
  desc "Reversible directory-local environment variable manipulations"
  homepage "https://shopify.github.io/shadowenv/"
  url "https://github.com/Shopify/shadowenv/archive/refs/tags/3.0.3.tar.gz"
  sha256 "ad04e1d5ae88e358f0ee6ec987bd88b7f8c489409fafc6286690aeacb074ddea"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93a3aa92e6d4f3d71f2096def300b3d503b06af579212990958fb29a5cf53dac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "926abc552d85283e6507cd2668bdf5af33ce5d2b0a3515fc14ab3a9250d8c6d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "801c925456a0220534c28009729ddb366a5925a61857c3ea053d39d6b44982b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "a584d3fa65f210eb2ea6dffd8d50b59b6cab767f11b7e97cf9bb2dde03fa2f2e"
    sha256 cellar: :any_skip_relocation, ventura:       "50f747135333edf3cc9f6252e6e4abc86ee20523c285af87a0d6411b843ae0d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "304f0b91b0e1699a4dbca9fffe327975fd4f86aa7d0a2a393233619c97d189b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4209ba91154dc46bc9254f7117cc25f46a7bc9ee0ce160321cc91d3a1bc81380"
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
