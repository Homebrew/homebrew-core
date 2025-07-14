class Shadowenv < Formula
  desc "Reversible directory-local environment variable manipulations"
  homepage "https://shopify.github.io/shadowenv/"
  url "https://github.com/Shopify/shadowenv/archive/refs/tags/3.3.1.tar.gz"
  sha256 "726c2a655749213cd7f0efe9dca199f65c11b58774c5550ea4834d5b2334b27c"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcea2f7cf59a7931a0d01f2418741839db84fe32c63e245b58e8dc7a2cacde4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "201b6122ba97b02c416c6e0eaad546c1cf02ce7603b4f2926e8bac164ca55613"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3410ab00b6cc4e35cf3ec29c63bd94076c277453f773bc2a0ed3231c4a624779"
    sha256 cellar: :any_skip_relocation, sonoma:        "f0f2ffb340fb507e7bea9cfab10bf5906a2cd3d0277436927cafab628e009d76"
    sha256 cellar: :any_skip_relocation, ventura:       "f8ee16f106a7088f298cde2a4f8086f18487ed55cdfebbab97a695b15b81f641"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "153277ad82d51bfa7ae899b1bb8798b863fc421c9c0a7fcfaf0db1bd3662d9ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49b2be347183407b5a356c147defe9b8eaf418d735380865e1e1e4250e0b083d"
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
