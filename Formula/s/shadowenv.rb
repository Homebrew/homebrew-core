class Shadowenv < Formula
  desc "Reversible directory-local environment variable manipulations"
  homepage "https://shopify.github.io/shadowenv/"
  url "https://github.com/Shopify/shadowenv/archive/2.1.1.tar.gz"
  sha256 "d9bf043f376b18255d124a9b90eb67d80d2f971bcd49090e84703b61dee03910"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b057830c9b7314bca810275833a19bf287f77c3fc36ce3dbb2f8f7cc9647e22"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50d8d4dfcf9e64546e965c942f6a125bcfcb94a42253058b667238ff7c81899c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d8ed9566680168ecd23a35843069d9f50bf7cd0b9902effdd29a923deda9c792"
    sha256 cellar: :any_skip_relocation, ventura:        "b96c4530ee1f23877cf87877218465d03bf9e52f69d5638b8bbd8ad0d66a2e22"
    sha256 cellar: :any_skip_relocation, monterey:       "bc2b03d6af4c10ba31381997ffd327489ea47abf064256709ef916036dd04867"
    sha256 cellar: :any_skip_relocation, big_sur:        "91ae639111876468b02121c8bf16300418c8aa2c87d8378045226dea145cc77a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "375fd1676c290cf6704b90657ab7cd11ecd56b4da72f2505354f8bbe486eedbf"
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
